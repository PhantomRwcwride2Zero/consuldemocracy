require "rails_helper"

describe "Comments" do
  let(:factory) {
                    [
                      :budget_investment,
                      :debate,
                      :legislation_annotation,
                      :legislation_question,
                      :poll,
                      :proposal,
                      :topic_with_community,
                      :topic_with_investment_community
                    ].sample
                  }
  let(:resource) { create(factory) }
  let(:user) { create(:user, :level_two) }
  let(:fill_text) do
    if factory == :legislation_question
      "Leave your answer"
    else
      "Leave your comment"
    end
  end
  let(:button_text) do
    if factory == :legislation_question
      "Publish answer"
    else
      "Publish comment"
    end
  end

  describe "Index" do
    context "Budget Investments" do
      let(:investment) { create(:budget_investment) }

      scenario "render comments" do
        not_valuations = 3.times.map { create(:comment, commentable: investment) }
        create(:comment, :valuation, commentable: investment, subject: "Not viable")

        visit budget_investment_path(investment.budget, investment)

        expect(page).to have_css(".comment", count: 3)
        expect(page).not_to have_content("Not viable")

        within("#comments") do
          not_valuations.each do |comment|
            expect(page).to have_content comment.user.name
            expect(page).to have_content I18n.l(comment.created_at, format: :datetime)
            expect(page).to have_content comment.body
          end
        end
      end
    end

    context "Debates, annotations, question, Polls, Proposals and Topics" do
      let(:factory) do
        [
          :debate, :legislation_annotation, :legislation_question, :poll, :proposal,
          :topic_with_community, :topic_with_investment_community
        ].sample
      end

      scenario "render comments" do
        3.times { create(:comment, commentable: resource) }
        comment = Comment.includes(:user).last

        visit polymorphic_path(resource)

        if factory == :legislation_annotation
          expect(page).to have_css(".comment", count: 4)
        else
          expect(page).to have_css(".comment", count: 3)
        end

        within first(".comment") do
          expect(page).to have_content comment.user.name
          expect(page).to have_content I18n.l(comment.created_at, format: :datetime)
          expect(page).to have_content comment.body
        end
      end
    end
  end

  scenario "Show" do
    parent_comment = create(:comment, commentable: resource, body: "Parent")
    create(:comment, commentable: resource, parent: parent_comment, body: "First subcomment")
    create(:comment, commentable: resource, parent: parent_comment, body: "Last subcomment")

    visit comment_path(parent_comment)

    expect(page).to have_css(".comment", count: 3)
    expect(page).to have_content "Parent"
    expect(page).to have_content "First subcomment"
    expect(page).to have_content "Last subcomment"

    expect(page).to have_link "Go back to #{resource.title}",
                              href: polymorphic_path(resource)

    within ".comment", text: "Parent" do
      expect(page).to have_css ".comment", count: 2
    end
  end

  scenario "Link to comment show" do
    comment = create(:comment, commentable: resource, user: user)

    visit polymorphic_path(resource)

    within "#comment_#{comment.id}" do
      expect(page).to have_link comment.created_at.strftime("%Y-%m-%d %T")
      click_link comment.created_at.strftime("%Y-%m-%d %T")
    end

    expect(page).to have_link "Go back to #{resource.title}"
    expect(page).to have_current_path(comment_path(comment))
  end

  scenario "Collapsable comments" do
    if factory == :legislation_annotation
      parent_comment = resource.comments.first
    else
      parent_comment = create(:comment, body: "Main comment", commentable: resource)
    end
    child_comment = create(:comment,
                           body: "First subcomment",
                           commentable: resource,
                           parent: parent_comment)
    grandchild_comment = create(:comment,
                                body: "Last subcomment",
                                commentable: resource,
                                parent: child_comment)

    visit polymorphic_path(resource)

    expect(page).to have_css(".comment", count: 3)
    expect(page).to have_content("1 response (collapse)", count: 2)

    within ".comment .comment", text: "First subcomment" do
      click_link text: "1 response (collapse)"
    end

    expect(page).to have_css(".comment", count: 2)
    expect(page).to have_content("1 response (collapse)")
    expect(page).to have_content("1 response (show)")
    expect(page).not_to have_content grandchild_comment.body

    within ".comment .comment", text: "First subcomment" do
      click_link text: "1 response (show)"
    end

    expect(page).to have_css(".comment", count: 3)
    expect(page).to have_content("1 response (collapse)", count: 2)
    expect(page).to have_content grandchild_comment.body

    within ".comment", text: parent_comment.body do
      click_link text: "1 response (collapse)", match: :first
    end

    expect(page).to have_css(".comment", count: 1)
    expect(page).to have_content("1 response (show)")
    expect(page).not_to have_content child_comment.body
    expect(page).not_to have_content grandchild_comment.body
  end

  describe "Not logged user" do
    scenario "can not see comments forms" do
      create(:comment, commentable: resource)

      visit polymorphic_path(resource)

      expect(page).to have_content "You must sign in or sign up to leave a comment"
      within("#comments") do
        expect(page).not_to have_content fill_text
        expect(page).not_to have_content "Reply"
      end
    end
  end

  scenario "Comment order" do
    c1 = create(:comment, :with_confidence_score, commentable: resource, cached_votes_up: 100,
                                                  cached_votes_total: 120, created_at: Time.current - 2)
    c2 = create(:comment, :with_confidence_score, commentable: resource, cached_votes_up: 10,
                                                  cached_votes_total: 12, created_at: Time.current - 1)
    c3 = create(:comment, :with_confidence_score, commentable: resource, cached_votes_up: 1,
                                                  cached_votes_total: 2, created_at: Time.current)

    visit polymorphic_path(resource, order: :most_voted)

    expect(c1.body).to appear_before(c2.body)
    expect(c2.body).to appear_before(c3.body)

    click_link "Newest first"

    expect(page).to have_link "Newest first", class: "is-active"
    expect(page).to have_current_path(/#comments/, url: true)
    expect(c3.body).to appear_before(c2.body)
    expect(c2.body).to appear_before(c1.body)

    click_link "Oldest first"

    expect(page).to have_link "Oldest first", class: "is-active"
    expect(page).to have_current_path(/#comments/, url: true)
    expect(c1.body).to appear_before(c2.body)
    expect(c2.body).to appear_before(c3.body)
  end

  scenario "Errors on create" do
    login_as(user)
    visit polymorphic_path(resource)

    click_button button_text

    expect(page).to have_content "Can't be blank"
  end
end
