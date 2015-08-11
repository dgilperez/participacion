require 'rails_helper'

feature 'Moderate Comments' do

  scenario 'Hide', :js do
    citizen = create(:user)
    moderator = create(:moderator)

    debate = create(:debate)
    comment = create(:comment, commentable: debate, body: 'SPAM')

    login_as(moderator.user)
    visit debate_path(debate)

    within("#comment_#{comment.id}") do
      click_link 'Hide'
    end

    login_as(citizen)
    visit debate_path(debate)

    expect(page).to have_css('.comment', count: 0)
  end

  scenario 'Hide thread', :js do
    citizen = create(:user)
    moderator = create(:moderator)

    debate = create(:debate)
    comment = create(:comment, commentable: debate, body: 'SPAM')
    reply = create(:comment, commentable: debate, body: 'More SPAM', parent_id: comment.id)

    login_as(moderator.user)
    visit debate_path(debate)

    within("#comment_#{comment.id}") do
      first(:link, "Hide").click
    end

    login_as(citizen)
    visit debate_path(debate)

    expect(page).to have_css('.comment', count: 0)
  end

  scenario 'Restore', :js do
    citizen = create(:user)
    moderator = create(:moderator)

    debate = create(:debate)
    comment = create(:comment, :hidden, commentable: debate, body: 'SPAM')

    login_as(moderator.user)
    visit debate_path(debate)

    click_link "Show all hidden"
    within("#comment_#{comment.id}") do
      first(:link, "Allow").click
    end

    login_as(citizen)
    visit debate_path(debate)

    expect(page).to have_css('.comment', count: 1)
  end

  scenario 'Restore thread', :js do
    citizen = create(:user)
    moderator = create(:moderator)

    debate = create(:debate)
    comment = create(:comment, :hidden, commentable: debate, body: "SPAM")
    reply = create(:comment, commentable: debate, body: 'More SPAM', parent_id: comment.id)

    login_as(moderator.user)
    visit debate_path(debate)

    click_link "Show all hidden"
    within("#comment_#{comment.id}") do
      click_link 'Allow'
    end

    login_as(citizen)
    visit debate_path(debate)

    expect(page).to have_css('.comment', count: 2)
  end

  scenario 'Moderator actions' do
    citizen = create(:user)
    moderator = create(:moderator)

    debate = create(:debate)
    comment = create(:comment, commentable: debate)

    login_as(moderator.user)
    visit debate_path(debate)

    expect(page).to have_css("a", text: "Show all hidden")
    expect(page).to have_css("#moderator-comment-actions")

    login_as(citizen)
    visit debate_path(debate)

    expect(page).to_not have_css("a", text: "Show all hidden")
    expect(page).to_not have_css("#moderator-comment-actions")
  end

  scenario 'Hidden comments' do
    citizen = create(:user)
    moderator = create(:moderator)

    debate = create(:debate)
    comment = create(:comment, :hidden, commentable: debate, body: 'SPAM')
    reply = create(:comment, :hidden, commentable: debate, body: 'More SPAM', parent_id: comment.id)

    login_as(moderator.user)
    visit debate_path(debate)

    expect(page).to have_css(".comment.hidden", text: "SPAM")
    expect(page).to have_css(".comment.hidden .comment.hidden", text: "More SPAM")

    login_as(citizen)
    visit debate_path(debate)

    expect(page).to_not have_css(".comment.hidden", text: "SPAM")
    expect(page).to_not have_css(".comment.hidden .comment.hidden", text: "More SPAM")
  end

end