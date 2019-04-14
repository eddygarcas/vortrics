
require 'test/unit'
require 'test_helper'
require 'mocha/test_unit'
require_relative '../../app/models/issue'
class IssueTest < Test::Unit::TestCase
  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    # Do nothing
    @issue = Issue.new()
    @test = mock()
    @jira_issue = JiraIssue.new
    @elem_string= {'expand'=>'operations,versionedRepresentations,editmeta,changelog,renderedFields', 'id'=>'442199', 'self'=>'https://jira.schibsted.io/rest/agile/1.0/issue/442199', 'key'=>'EP-2688', 'fields'=>{'summary'=>'devhose client may loose messages in the worker on shutdown', 'issuetype'=>{'self'=>'https://jira.schibsted.io/rest/api/2/issuetype/1', 'id'=>'1', 'description'=>'A problem that prevents a system function according to specification', 'iconUrl'=>'https://jira.schibsted.io/secure/viewavatar?size=xsmall&avatarId=10304&avatarType=issuetype', 'name'=>'Bug', 'subtask'=>false, 'avatarId'=>10304}, 'components'=>[{'self'=>'https://jira.schibsted.io/rest/api/2/component/12214', 'id'=>'12214', 'name'=>'EngProd Common', 'description'=>'Team infrastructure'}], 'created'=>'2018-05-17T10:05:45.000+0000', 'timeoriginalestimate'=>nil, 'description'=>nil, 'priority'=>{'self'=>'https://jira.schibsted.io/rest/api/2/priority/10000', 'iconUrl'=>'https://jira.schibsted.io/images/icons/priorities/trivial.svg', 'name'=>'None', 'id'=>'10000'}, 'customfield_10002'=>2.0, 'resolutiondate'=>'2018-05-22T09:05:59.000+0000', 'closedSprints'=>[{'id'=>5760, 'self'=>'https://jira.schibsted.io/rest/agile/1.0/sprint/5760', 'state'=>'closed', 'name'=>'EP Tools Sprint 13', 'startDate'=>'2018-05-15T10:39:48.911Z', 'endDate'=>'2018-05-22T11:05:00.000Z', 'completeDate'=>'2018-05-22T10:11:10.336Z', 'originBoardId'=>1613, 'goal'=>''}], 'assignee'=>{'self'=>'https://jira.schibsted.io/rest/api/2/user?username=xavi.leon%40schibsted.com', 'name'=>'xavi.leon@schibsted.com', 'key'=>'xavi.leon@schibsted.com', 'emailAddress'=>'xavi.leon@schibsted.com', 'avatarUrls'=>{'48x48'=>'https://jira.schibsted.io/secure/useravatar?ownerId=xavi.leon%40schibsted.com&avatarId=14437', '24x24'=>'https://jira.schibsted.io/secure/useravatar?size=small&ownerId=xavi.leon%40schibsted.com&avatarId=14437', '16x16'=>'https://jira.schibsted.io/secure/useravatar?size=xsmall&ownerId=xavi.leon%40schibsted.com&avatarId=14437', '32x32'=>'https://jira.schibsted.io/secure/useravatar?size=medium&ownerId=xavi.leon%40schibsted.com&avatarId=14437'}, 'displayName'=>'Xavier León', 'active'=>true, 'timeZone'=>'Etc/UTC'}, 'updated'=>'2018-05-22T09:05:59.000+0000', 'status'=>{'self'=>'https://jira.schibsted.io/rest/api/2/status/10311', 'description'=>'Done', 'iconUrl'=>'https://jira.schibsted.io/images/icons/statuses/closed.png', 'name'=>'Done', 'id'=>'10311', 'statusCategory'=>{'self'=>'https://jira.schibsted.io/rest/api/2/statuscategory/3', 'id'=>3, 'key'=>'done', 'colorName'=>'green', 'name'=>'Done'}}}, 'changelog'=>{'startAt'=>0, 'maxResults'=>5, 'total'=>5, 'histories'=>[{'id'=>'2294760', 'author'=>{'self'=>'https://jira.schibsted.io/rest/api/2/user?username=xavi.leon%40schibsted.com', 'name'=>'xavi.leon@schibsted.com', 'key'=>'xavi.leon@schibsted.com', 'emailAddress'=>'xavi.leon@schibsted.com', 'avatarUrls'=>{'48x48'=>'https://jira.schibsted.io/secure/useravatar?ownerId=xavi.leon%40schibsted.com&avatarId=14437', '24x24'=>'https://jira.schibsted.io/secure/useravatar?size=small&ownerId=xavi.leon%40schibsted.com&avatarId=14437', '16x16'=>'https://jira.schibsted.io/secure/useravatar?size=xsmall&ownerId=xavi.leon%40schibsted.com&avatarId=14437', '32x32'=>'https://jira.schibsted.io/secure/useravatar?size=medium&ownerId=xavi.leon%40schibsted.com&avatarId=14437'}, 'displayName'=>'Xavier León', 'active'=>true, 'timeZone'=>'Etc/UTC'}, 'created'=>'2018-05-17T10:05:48.053+0000', 'items'=>[{'field'=>'Sprint', 'fieldtype'=>'custom', 'from'=>nil, 'fromString'=>nil, 'to'=>'5760', 'toString'=>'EP Tools Sprint 13'}]}, {'id'=>'2294761', 'author'=>{'self'=>'https://jira.schibsted.io/rest/api/2/user?username=xavi.leon%40schibsted.com', 'name'=>'xavi.leon@schibsted.com', 'key'=>'xavi.leon@schibsted.com', 'emailAddress'=>'xavi.leon@schibsted.com', 'avatarUrls'=>{'48x48'=>'https://jira.schibsted.io/secure/useravatar?ownerId=xavi.leon%40schibsted.com&avatarId=14437', '24x24'=>'https://jira.schibsted.io/secure/useravatar?size=small&ownerId=xavi.leon%40schibsted.com&avatarId=14437', '16x16'=>'https://jira.schibsted.io/secure/useravatar?size=xsmall&ownerId=xavi.leon%40schibsted.com&avatarId=14437', '32x32'=>'https://jira.schibsted.io/secure/useravatar?size=medium&ownerId=xavi.leon%40schibsted.com&avatarId=14437'}, 'displayName'=>'Xavier León', 'active'=>true, 'timeZone'=>'Etc/UTC'}, 'created'=>'2018-05-17T10:05:48.187+0000', 'items'=>[{'field'=>'Rank', 'fieldtype'=>'custom', 'from'=>'', 'fromString'=>'', 'to'=>'', 'toString'=>'Ranked higher'}]}, {'id'=>'2294762', 'author'=>{'self'=>'https://jira.schibsted.io/rest/api/2/user?username=xavi.leon%40schibsted.com', 'name'=>'xavi.leon@schibsted.com', 'key'=>'xavi.leon@schibsted.com', 'emailAddress'=>'xavi.leon@schibsted.com', 'avatarUrls'=>{'48x48'=>'https://jira.schibsted.io/secure/useravatar?ownerId=xavi.leon%40schibsted.com&avatarId=14437', '24x24'=>'https://jira.schibsted.io/secure/useravatar?size=small&ownerId=xavi.leon%40schibsted.com&avatarId=14437', '16x16'=>'https://jira.schibsted.io/secure/useravatar?size=xsmall&ownerId=xavi.leon%40schibsted.com&avatarId=14437', '32x32'=>'https://jira.schibsted.io/secure/useravatar?size=medium&ownerId=xavi.leon%40schibsted.com&avatarId=14437'}, 'displayName'=>'Xavier León', 'active'=>true, 'timeZone'=>'Etc/UTC'}, 'created'=>'2018-05-17T10:06:08.046+0000', 'items'=>[{'field'=>'status', 'fieldtype'=>'jira', 'from'=>'10000', 'fromString'=>'To Do', 'to'=>'3', 'toString'=>'In Progress'}]}, {'id'=>'2296120', 'author'=>{'self'=>'https://jira.schibsted.io/rest/api/2/user?username=xavi.leon%40schibsted.com', 'name'=>'xavi.leon@schibsted.com', 'key'=>'xavi.leon@schibsted.com', 'emailAddress'=>'xavi.leon@schibsted.com', 'avatarUrls'=>{'48x48'=>'https://jira.schibsted.io/secure/useravatar?ownerId=xavi.leon%40schibsted.com&avatarId=14437', '24x24'=>'https://jira.schibsted.io/secure/useravatar?size=small&ownerId=xavi.leon%40schibsted.com&avatarId=14437', '16x16'=>'https://jira.schibsted.io/secure/useravatar?size=xsmall&ownerId=xavi.leon%40schibsted.com&avatarId=14437', '32x32'=>'https://jira.schibsted.io/secure/useravatar?size=medium&ownerId=xavi.leon%40schibsted.com&avatarId=14437'}, 'displayName'=>'Xavier León', 'active'=>true, 'timeZone'=>'Etc/UTC'}, 'created'=>'2018-05-17T15:03:16.512+0000', 'items'=>[{'field'=>'Story Points', 'fieldtype'=>'custom', 'from'=>nil, 'fromString'=>nil, 'to'=>nil, 'toString'=>'2'}]}, {'id'=>'2307663', 'author'=>{'self'=>'https://jira.schibsted.io/rest/api/2/user?username=xavi.leon%40schibsted.com', 'name'=>'xavi.leon@schibsted.com', 'key'=>'xavi.leon@schibsted.com', 'emailAddress'=>'xavi.leon@schibsted.com', 'avatarUrls'=>{'48x48'=>'https://jira.schibsted.io/secure/useravatar?ownerId=xavi.leon%40schibsted.com&avatarId=14437', '24x24'=>'https://jira.schibsted.io/secure/useravatar?size=small&ownerId=xavi.leon%40schibsted.com&avatarId=14437', '16x16'=>'https://jira.schibsted.io/secure/useravatar?size=xsmall&ownerId=xavi.leon%40schibsted.com&avatarId=14437', '32x32'=>'https://jira.schibsted.io/secure/useravatar?size=medium&ownerId=xavi.leon%40schibsted.com&avatarId=14437'}, 'displayName'=>'Xavier León', 'active'=>true, 'timeZone'=>'Etc/UTC'}, 'created'=>'2018-05-22T09:05:59.112+0000', 'items'=>[{'field'=>'status', 'fieldtype'=>'jira', 'from'=>'3', 'fromString'=>'In Progress', 'to'=>'10311', 'toString'=>'Done'}, {'field'=>'resolution', 'fieldtype'=>'jira', 'from'=>nil, 'fromString'=>nil, 'to'=>'10000', 'toString'=>'Done'}]}]}}

  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def test_parse_nested_object
    @issue.public_methods(false).select { |method| method unless method.to_s.include?("=")}.each { |elem|
      puts "Getter method #{elem}"

    }
  end

  def test_parse_element
    issue_methods = @jira_issue.public_methods(false).map {|method| method.to_s.delete('?=') }
    assert_not_empty issue_methods
    total_methods = issue_methods.count
    issue_methods.uniq!
    assert_not_equal total_methods, issue_methods.count
    elem_methods = (issue_methods + @elem_string['fields'].keys).uniq
    assert_equal issue_methods.count, elem_methods.count
  end

  def test_jira_parse_issue
    issue = JiraIssue.new(@elem_string)
    assert_true issue.respond_to? "customfield_10002"
    assert_equal 2.0, issue.customfield_10002
  end


end