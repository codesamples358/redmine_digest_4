class AddNotifyOptionsToDigestRules < PLUGIN_MIGRATION_CLASS
  def change
    add_column :digest_rules, :notify, :string, default: 'all'
  end
end
