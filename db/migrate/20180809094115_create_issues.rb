class CreateIssues < ActiveRecord::Migration[5.1]
  def change
    #:key, :issuetype, :summary, :customfield_11802, :customfield_11382, :description, :priority, :components, :status, :project, :assignee, :created, :updated, :resolutiondate
    create_table :issues do |t|
      t.string :key                 , null: false
      t.string :issuetype           , null: true
      t.string :summary             , null: true
      t.integer :customfield_11802  , null: true, default: 0
      t.string :customfield_11382   , null: true, default: ""
      t.string :description         , null: true
      t.string :priority            , null: true
      t.string :components          , null: true
      t.string :status              , null: true
      t.string :project             , null: true
      t.string :assignee            , null: true
      t.datetime :created           , null: true
      t.datetime :updated           , null: true
      t.datetime :resolutiondate  , null: true
      t.references :sprint    , foreign_key: true
      t.timestamps
    end
  end
end
