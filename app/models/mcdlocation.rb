class Mcdlocation
  include DataMapper::Resource
  include DataMapper::GeoKit
  
  property :id, Serial
  property :natid, Integer
  property :phone, String
  property :coop, String
  property :open247, Boolean
  property :active, Boolean
  has_geographic_location :loc


  # Import Data from CSV for all MCD locations
  def self.import_csv
    include CsvMapper
    csv_data = CsvMapper.import('./tmp/mcdlist.csv') do
      read_attributes_from_file
    end

    for csv_loc in csv_data
      csv_loc_address = "#{csv_loc.storeaddress} #{csv_loc.city}, #{csv_loc.state} #{csv_loc.zip}"
      first_loc = Mcdlocation.create(
        :natid => csv_loc.national, 
        :phone => csv_loc.storephone,
        :open247 => true,
        :coop => csv_loc.coop, 
        :loc => csv_loc_address
      )
    end
  end
  
  def self.locate(args)
    radius = args[:radius].to_i.mi || 5.mi
    locations = Mcdlocation.all(:loc.near => {:origin => args[:query], :distance => radius}, :conditions => ['1 = 1'], :fields => nil, :order => [:loc_distance.asc])
    response = {
      :results => locations
    }
  end

end
