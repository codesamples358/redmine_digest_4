class DigestEvent::DescriptionChanged < DigestEvent::Base
  def event_summary
    "#{user_stamp}: #{cutted_text(value)}"
  end

  private

  def format_value(val)
    val.nil? ? '-' : cutted_text(val)
  end
end
