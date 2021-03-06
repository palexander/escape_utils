# encoding: UTF-8
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper.rb')
require 'uri'

describe EscapeUtils, "escape_uri" do
  it "should respond to escape_uri" do
    EscapeUtils.should respond_to(:escape_uri)
  end

  it "should escape each byte exactly like URI.escape" do
    (0..127).each do |i|
      c = i.chr
      EscapeUtils.escape_uri(c).should eql(URI.escape(c))
    end
  end

  # NOTE: from Rack's test suite
  it "should escape a url containing tags" do
    EscapeUtils.escape_uri("fo<o>bar").should eql("fo%3Co%3Ebar")
  end

  # NOTE: from Rack's test suite
  it "should escape a url with spaces" do
    EscapeUtils.escape_uri("a space").should eql("a%20space")
    EscapeUtils.escape_uri("a   sp ace ").should eql("a%20%20%20sp%20ace%20")
  end

  # NOTE: from Rack's test suite
  it "should escape correctly for multibyte characters" do
    matz_name = "\xE3\x81\xBE\xE3\x81\xA4\xE3\x82\x82\xE3\x81\xA8" # Matsumoto
    EscapeUtils.escape_uri(matz_name).should eql('%E3%81%BE%E3%81%A4%E3%82%82%E3%81%A8')
    matz_name_sep = "\xE3\x81\xBE\xE3\x81\xA4 \xE3\x82\x82\xE3\x81\xA8" # Matsu moto
    EscapeUtils.escape_uri(matz_name_sep).should eql('%E3%81%BE%E3%81%A4%20%E3%82%82%E3%81%A8')
  end

  if RUBY_VERSION =~ /^1.9/
    it "input must be UTF-8 or US-ASCII" do
      str = "fo<o>bar"

      str.force_encoding 'ISO-8859-1'
      lambda {
        EscapeUtils.escape_uri(str)
      }.should raise_error(Encoding::CompatibilityError)

      str.force_encoding 'UTF-8'
      lambda {
        EscapeUtils.escape_uri(str)
      }.should_not raise_error(Encoding::CompatibilityError)
    end

    it "return value should be in UTF-8" do
      str = "fo<o>bar"
      EscapeUtils.escape_uri(str).encoding.should eql(Encoding.find('UTF-8'))
    end
  end
end