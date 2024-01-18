# name: discourse-user-auto-activation
# about: Auto activate new accounts
# authors: Alex Wang
# version: 1.1


after_initialize do
  # Rails Engine for accepting votes.
  module AutoActivationPlugin
    require_dependency 'users_controller'
    require_dependency 'user'

    User.class_eval do
      def create_email_token
        email_tokens.create(email: email) unless SiteSetting.auto_activation_enabled
      end
    end
    UsersController.class_eval do
      private

      def user_params
        merge_fields = { ip_address: request.ip }
        merge_fields.merge!(active: true) if SiteSetting.auto_activation_enabled

        existing_permitted_params = params.permit!
        existing_permitted_params.merge(merge_fields)

        # Whitelist the merged params
         ActionController::Parameters.new(my_merged_params).permit!

      end
    end
  end
end
