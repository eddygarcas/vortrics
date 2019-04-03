require 'test/unit'
require 'test_helper'
require_relative '../../app/models/issue'
class IssueTest < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    # Do nothing
    @issue = Issue.new()
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def test_parse_nested_object
    @issue.public_methods(false).select { |method| method unless method.to_s.include?("=")}.each { |elem|
      puts "Getter method #{elem}"

    }
  end


end