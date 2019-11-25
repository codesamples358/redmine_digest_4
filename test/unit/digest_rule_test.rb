require File.expand_path('../../test_helper', __FILE__)

class DigestRuleTest < ActiveSupport::TestCase
  fixtures :users, :user_preferences, :roles, :projects, :members, :member_roles, :email_addresses,
           :issues, :issue_statuses, :trackers, :journals, :journal_details,
           :enabled_modules

  def setup
    @user = User.find(2)
  end

  def test_include_issue_on_create
    rule = @user.digest_rules.create(
      name:             'test_include_on_create',
      recurrent:        DigestRule::MONTHLY,
      project_selector: DigestRule::SELECTED,
      raw_project_ids:  '1',
      event_ids:        [DigestEvent::ISSUE_CREATED]
    )

    assert_equal true, rule.apply_for_created_issue?(Issue.find(1))
    assert_equal false, rule.apply_for_created_issue?(Issue.find(4))
  end

  def test_do_not_include_issue_on_create
    rule = @user.digest_rules.create(
      name:             'test_include_on_create',
      recurrent:        DigestRule::MONTHLY,
      project_selector: DigestRule::SELECTED,
      raw_project_ids:  '1',
      event_ids:        []
    )

    assert_equal false, rule.apply_for_created_issue?(Issue.find(1))
    assert_equal false, rule.apply_for_created_issue?(Issue.find(4))
  end

  def test_include_journal_on_update
    rule    = @user.digest_rules.create(
      name:             'test',
      recurrent:        DigestRule::MONTHLY,
      project_selector: DigestRule::SELECTED,
      raw_project_ids:  '1',
      event_ids:        DigestEvent::TYPES
    )
    journal = Journal.find(1) # issue_id: 1, changed status and done_ratio

    assert_equal true, rule.apply_for_updated_issue?(journal)
  end

  def test_do_not_include_journal_on_update
    rule    = @user.digest_rules.create(
      name:             'test',
      recurrent:        DigestRule::MONTHLY,
      project_selector: DigestRule::SELECTED,
      raw_project_ids:  '1',
      event_ids:        [DigestEvent::ASSIGNEE_CHANGED,
                         DigestEvent::VERSION_CHANGED,
                         DigestEvent::ISSUE_CREATED]
    )
    journal = Journal.find(1) # issue_id: 1, changed status and done_ratio

    assert_equal false, rule.apply_for_updated_issue?(journal)
  end

end
