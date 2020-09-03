Rails.application.routes.draw do

  mount ActionCable.server => '/cable'

  resources :postits
	resources :settings, except: :show
  resources :components
  resources :sprints
  resources :teams
  resources :issues
  resources :advices
  resources :comments
  resources :kanban
  resources :cards do
    member do
      patch :move
    end
  end
  resources :workflows do
    member do
      patch :move
    end
  end
  resources :notifications do
    collection do
      post :mark_as_read
    end
  end
  resources :retrospectives do
    member do
      patch :move
    end
  end
  resources :postits do
    member do
      patch :move
      post :vote
      post :save
    end
  end

  devise_for :users, controllers: {registrations: 'registrations', omniauth_callbacks: 'users/omniauth_callbacks'}
  match 'users/:id', to: 'users#destroy', via: :delete, as: :admin_destroy_user
  get '/users/manage_users', to: 'users#manage_users', as: 'devise_manage_users'
	post '/users/manage_users', to: 'users#create'
	get '/users', to: 'users#index', as: 'users_index'
  post '/users/group', to: 'users#group_assigment', as: 'users_update_group'
	post '/users/config', to: 'users#setting_assigment', as: 'users_update_setting'

  get '/signin', to: 'jira_sessions#new'
  get '/callback', to: 'jira_sessions#authorize'
  get '/signout', to: 'jira_sessions#destroy'

  get '/oauth', to: 'trello_sessions#new'
  get '/oauth/authorize', to: 'trello_sessions#authorize', as:'oauth_authorize'

  get '/teams/:id/graph_points', to: 'teams#get_graph_data'
  get '/teams/:id/graph_stories', to: 'teams#get_graph_stories'
  get '/teams/:id/graph_bugs', to: 'teams#get_graph_bugs'
  get '/teams/:id/graph_leftovers', to: 'teams#stories_graph_data'
  get '/teams/:id/graph_no_estimates', to: 'teams#stories_points_graph_data'
  get '/teams/:id/graph_closed_by_day', to: 'teams#graph_closed_by_day'
  get '/teams/:id/graph_release_time', to: 'teams#graph_release_time'
  get '/teams/:id/graph_lead_time_bugs', to: 'teams#graph_lead_time_bugs'
  get '/teams/:id/graph_ratio_bugs_closed', to: 'teams#graph_ratio_bugs_closed'
  get '/teams/:id/graph_comulative_flow_diagram', to: 'teams#graph_comulative_flow_diagram'
  get '/teams/:id/graph_time_first_response', to: 'teams#graph_time_first_response'
  post '/teams/:id/cycle_time_chart', to: 'teams#cycle_time_chart'
  get '/teams/:id/key_results', to: 'teams#key_results', as: 'teams_key_results'
  get '/teams/:id/comulative_flow_diagram', to: 'teams#comulative_flow_diagram', as:'teams_comulative_flow_diagram'
  get '/teams/:id/support', to: 'teams#support', as: 'teams_support'
  get '/teams/boards_by_team/:proj_id', to: 'teams#boards_by_team', as: 'teams_boards_by_team'
  get '/teams/full_project_details/:proj_id', to: 'teams#full_project_details', as: 'teams_full_project_details'

  get '/comments/by_board/:board_id', to:'comments#comments_by_board', as: 'comments_by_board'

  get '/montecarlo', to: 'montecarlo#show',as: 'montecarlo_show'
  post '/montecarlo/chart', to: 'montecarlo#montecarlo_chart', as: 'montecarlo_chart'


  get '/sprints/:id/graph_closed_by_day', to: 'sprints#graph_closed_by_day'
  get '/sprints/:id/graph_release_time', to: 'sprints#graph_release_time'
	get '/sprints/:proj_id/dashboard', to: 'sprints#dashboards', as: 'sprints_dashboards'

  # Will make board_id optional
  get '/import/sprint(/:board_id)', to: 'sprints#import', as: 'sprint_import'
  get '/import/issues', to: 'sprints#import_issues', as: 'sprint_import_issues'
  get '/refresh/:id/issues', to: 'sprints#refresh_issues', as: 'sprint_refresh_issues'

  get '/issues/sprint/:sprint_id', to: 'issues#sprint_issues', as: 'sprint_issues'
  get '/issues/key/:key', to:"issues#show", as: 'issues_key_show'
  post '/issues/search', to: 'issues#search', as: 'issues_search'

  get '/import/kanban(/:board_id)', to: 'kanban#import_issues', as: 'kanban_import_issues'

  get '/:id', to: 'home#dashboard', as: 'get_dashboard'
  #get '/:id/refresh', to: 'home#refresh', as: 'refresh_path'

	get '/landing/info', to: 'landing#info', as: 'landing_info'
  get '/landing/error/401', to: 'landing#error_401', as: 'landing_error_401'
  get '/landing/error/403', to: 'landing#error_403', as: 'landing_error_403'
	post '/register', to: 'landing#register', as: 'landing_register'

  post '/advices/mark_as_read', to: 'advices#mark_as_read', as: 'advices_mark_as_read'

  root to: 'home#dashboard'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

end
