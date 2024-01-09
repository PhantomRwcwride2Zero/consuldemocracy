class Layout::FooterComponent < ApplicationComponent
  delegate :content_block, to: :helpers

  def footer_legal_content_block
    content_block("footer_legal")
  end

  private

    def open_source_link
      external_link_to(t("layouts.footer.open_source"), t("layouts.footer.open_source_url"))
    end

    def repository_link
      external_link_to(t("layouts.footer.consul"), t("layouts.footer.consul_url"))
    end

    def external_link_to(text, url)
      link_to(text, url, rel: "nofollow external")
    end

    def allowed_link_attributes
      self.class.sanitized_allowed_attributes + ["rel"]
    end

    def cookies_enabled?
      Setting["feature.cookies_consent"].presence &&
        (Setting["cookies_consent.third_party"].present? || ::Cookies::Vendor.any?)
    end
end
