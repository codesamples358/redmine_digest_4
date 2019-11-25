class AddTemplateToDigestRules < PLUGIN_MIGRATION_CLASS
  def change
    add_column :digest_rules, :template, :string, default: 'short'
  end
end
