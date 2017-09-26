class UserDecorator < Draper::Decorator
  delegate_all

  def name
    email.scan(/\w+/)[0..1].map(&:capitalize).join('. ')
  end
end
