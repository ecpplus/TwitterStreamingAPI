class TwitterSettings < Settingslogic
  source "#{Rails.root}/config/twitter.yml"
  namespace Rails.env
end
