# name: discourse-custom-app-banner
# about: have a custom app banner for whitelabeled app
# version: 1.0
# authors: richard@discoursehosting.com
# url: https://github.com/discoursehosting/discourse-custom-app-banner

enabled_site_setting :custom_app_banner_enabled

after_initialize do
  module AlternativeMetadataController
    def default_manifest
      manifest = super
      if SiteSetting.custom_app_banner_enabled && SiteSetting.custom_app_banner_android_app != ''
        manifest = manifest.merge({
          prefer_related_applications: true,
          related_applications: [
            {
              platform: "play",
              id: SiteSetting.custom_app_banner_android_app
            }
          ]
        })
      end

      manifest
    end
  end

  class ::MetadataController 
    prepend AlternativeMetadataController
  end
  
  register_html_builder('server:before-head-close') do
    if SiteSetting.custom_app_banner_enabled && SiteSetting.custom_app_banner_ios_app != ''
      "<meta name=\"apple-itunes-app\" content=\"app-id=#{SiteSetting.custom_app_banner_ios_app}\" />"
    end
  end
end

