require 'chef/resource'

class Chef
  class Resource
    # Resource for the tcp_tuning Chef provider
    #
    # tcp_tuning 'my-app' do
    #   settings 'smallest_anon_port' => 8192
    #   provider Chef::Provider::TCPTuning::Illumos
    # end
    #
    class TcpTuning < Chef::Resource
      def initialize(name, run_context = nil)
        super
        @resource_name = :tcp_tuning
        @provider = Chef::Provider::TcpTuning
        @action = :update
        @allowed_actions = [:update]
      end

      def name(arg = nil)
        set_or_return(:name, arg, kind_of: String)
      end

      def provider(arg = nil)
        set_or_return(:provider, arg, kind_of: Class)
      end

      def settings(arg = nil)
        set_or_return(:settings, arg, kind_of: Hash, required: true)
      end

      def default_provider
        case node.platform_family
        when 'smartos'
          Chef::Provider::TcpTuning::Illumos
        else
          Chef::Log.warn("No TcpTuning provider for platform_family: #{node.platform_family}")
          nil
        end
      end
    end
  end
end
