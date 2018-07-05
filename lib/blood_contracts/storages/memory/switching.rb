module BloodContracts
  module Storages
    class Memory
      class Switching
        ROOT_KEY = "blood_switcher".freeze

        attr_reader :global_store, :contract_name, :storage_klass
        def initialize(base_storage)
          @global_store = base_storage.global_store
          @contract_name = base_storage.contract_name
          @storage_klass = base_storage.storage_klass
        end

        attr_reader :storage
        def init
          @storage = global_store[root]
          return @storage unless @storage.nil?
          global_store[root] = storage_klass.new
          @storage = global_store[root]
        end

        def reset!
          global_store[all_contracts_key] = nil
          storage[contract_name] = nil
        end

        def enable_all!
          global_store[all_contracts_key] = true
        end

        def disable_all!
          global_store[all_contracts_key] = false
        end

        def enable!
          storage[contract_name] = true
        end

        def disable!
          storage[contract_name] = false
        end

        def enabled?
          contract_state = storage[contract_name]
          return contract_state unless contract_state.nil?
          return global_switcher_state if global_state_set?
          BloodContracts.config.enabled
        end

        private

        def global_switcher_state
          global_store[all_contracts_key]
        end

        def global_state_set?
          !global_store[all_contracts_key].nil?
        end

        def all_contracts_key
          "#{ROOT_KEY}-all-contracts-enabled"
        end

        # TODO: do we need `session` here?
        def root
          "#{ROOT_KEY}-#{contract_name}"
        end
      end
    end
  end
end
