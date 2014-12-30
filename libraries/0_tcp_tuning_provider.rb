require 'chef/provider'

class Chef
  class Provider
    # Provider for the tcp_tuning Chef provider
    #
    # tcp_tuning 'my-app' do
    #   settings 'smallest_anon_port' => 8192
    #   provider Chef::Provider::TCPTuning::Illumos
    # end
    #
    class TcpTuning < Chef::Provider::LWRPBase
      def load_current_resource
        @current_resource ||= new_resource.class.new(new_resource.name)
      end

      def action_update
        return unless new_resource.default_provider
        provider.run_action(:update)
      end

      private

      def provider
        new_resource.default_provider.new(new_resource, run_context)
      end
    end
  end
end
