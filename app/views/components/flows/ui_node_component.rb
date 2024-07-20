# frozen_string_literal: true


class Message
  attr_reader :id, :text, :type

  def initialize(message)
    @id = message["id"]
    @text = message["text"]
    @type = message["type"]
    @context = message["context"]
  end
end

class Flows::UiNodeComponent < ApplicationComponent
  renders_one :node

  def initialize(node)
    @id = get_random_id
    @node = node
    @meta = node["meta"]
    @attributes = node["attributes"]
    @type = node["type"]
    @group = node["group"]
    @messages = node["messages"].map do |message|
      Message.new(message)
    end
  end

  def has_label?
    @meta["label"].present?
  end

  def has_messages?
    @messages.length > 0
  end

  def get_name
    @attributes["name"] || @id
  end

  def get_type
    if @attributes
      _node_type = @attributes["node_type"]
      _type = @attributes["type"]

      _type || _node_type
    end
  end

  def is_button?
    if @attributes
      _type = @attributes["type"]

      _type == "submit" || _type == "button" || @type == "button"
    end

  end

  def is_script?
    if @attributes
      _type = @attributes["node_type"]

      _type == "script" || @type == "script"
    end
  end

  def is_link?

  end


  ##
  # @param attribute - A key value pair
  def get_attr(attribute)
    key, value = attribute

    if is_b?(value)
      return true?(value) ? "#{key}" : nil
    end

  if value.nil? || value.empty?
    return nil
    end

    "#{key}=#{value}"
  end
end

def is_b?(obj)
  true?(obj) || false?(obj)
end

def true?(obj)
  obj == true || obj.to_s.downcase == "true"
end

def false?(obj)
  obj == false || obj.to_s.downcase == "false"
end

##
# Generates a random id.
# Returns:: An 8 character long random id.
def get_random_id
  (0...8).map { (65 + rand(26)).chr }.join
end
