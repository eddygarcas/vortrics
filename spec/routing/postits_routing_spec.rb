require "rails_helper"

RSpec.describe PostitsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/postits").to route_to("postits#index")
    end

    it "routes to #new" do
      expect(:get => "/postits/new").to route_to("postits#new")
    end

    it "routes to #show" do
      expect(:get => "/postits/1").to route_to("postits#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/postits/1/edit").to route_to("postits#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/postits").to route_to("postits#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/postits/1").to route_to("postits#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/postits/1").to route_to("postits#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/postits/1").to route_to("postits#destroy", :id => "1")
    end
  end
end
