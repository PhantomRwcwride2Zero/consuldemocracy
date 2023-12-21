class Shared::CommentsFormComponent < ApplicationComponent
  attr_reader :commentable, :parent_id, :valuation
  delegate :current_user, :locale_and_user_status, :commentable_cache_key, :comments_closed_for_commentable?,
           :comments_closed_text, :require_verified_resident_for_commentable?, :link_to_verify_account,
           :parent_or_commentable_dom_id, :leave_comment_text, :can?, :comment_button_text, to: :helpers

  def initialize(commentable, parent_id: nil, valuation: false)
    @commentable = commentable
    @parent_id = parent_id
    @valuation = valuation
  end

  private

    def cache_key
      [
        locale_and_user_status,
        parent_id,
        commentable_cache_key(commentable),
        valuation
      ]
    end
end
