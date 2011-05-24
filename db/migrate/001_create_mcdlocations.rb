migration 1, :create_mcdlocations do
  up do
    create_table :mcdlocations do
      column :id, Integer, :serial => true
      column :natid, Integer
      column :phone, String
      column :coop, String
    end
  end

  down do
    drop_table :mcdlocations
  end
end
