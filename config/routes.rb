Rails.application.routes.draw do
	resources :settings, except: :show
  resources :assesments
  resources :q_stages
  resources :answers
  resources :questions
  resources :levels
  resources :maturity_frameworks
  resources :components
  resources :sprints
  resources :teams
  resources :issues
	resources :workflows
  resources :advices
  resources :comments
  resources :kanban
  resources :cards
  resources :notifications do
    collection do
      post :mark_as_read
    end
  end

  devise_for :users, controllers: {registrations: 'registrations'}
  match 'users/:id', to: 'users#destroy', via: :delete, as: :admin_destroy_user
  get '/users/manage_users', to: 'users#manage_users', as: 'devise_manage_users'
	post '/users/manage_users', to: 'users#create'
	get '/users', to: 'users#index', as: 'users_index'
  post '/users/group', to: 'users#group_assigment', as: 'users_update_group'
	post '/users/config', to: 'users#setting_assigment', as: 'users_update_setting'

  get '/signin', to: 'jira_sessions#new'
  get '/callback', to: 'jira_sessions#authorize'
  get '/signout', to: 'jira_sessions#destroy'

  put '/teams/:id/update_capacity', to: 'teams#update_capacity'
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
  get '/teams/:id/cycle_time_chart', to: 'teams#cycle_time_chart'
  get '/teams/:id/key_results', to: 'teams#key_results', as: 'teams_key_results'
  get '/teams/:id/comulative_flow_diagram', to: 'teams#comulative_flow_diagram', as:'teams_comulative_flow_diagram'
  get '/teams/boards_by_team/:proj_id', to: 'teams#boards_by_team', as: 'teams_boards_by_team'
  get '/teams/full_project_details/:proj_id', to: 'teams#full_project_details', as: 'teams_full_project_details'


  get '/sprints/:id/graph_closed_by_day', to: 'sprints#graph_closed_by_day'
  get '/sprints/:id/graph_release_time', to: 'sprints#graph_release_time'
	get '/sprints/:proj_id/dashboard', to: 'sprints#dashboards', as: 'sprints_dashboards'

  # Will make board_id optional
  get '/import/sprint(/:board_id)', to: 'sprints#import', as: 'sprint_import'
  get '/import/issues', to: 'sprints#import_issues', as: 'sprint_import_issues'
  get '/refresh/:id/issues', to: 'sprints#refresh_issues', as: 'sprint_refresh_issues'

  get '/issues/sprint/:sprint_id', to: 'issues#sprint_issues', as: 'sprint_issues'
  post '/issues/search', to: 'issues#search', as: 'issues_search'

  get '/import/kanban(/:board_id)', to: 'kanban#import_issues', as: 'kanban_import_issues'



  get '/:id', to: 'home#dashboard', as: 'get_dashboard'
  get '/:id/refresh', to: 'home#refresh', as: 'refresh_path'

  get '/assesments/:assesment_id/results', to: 'answers#results', as: 'assesment_result'
  get '/assesments/:assesment_id/answer', to: 'assesments#answer', as: 'assesment_answer'

	get '/landing/info', to: 'landing#info', as: 'landing_info'
	post '/register', to: 'landing#register', as: 'landing_register'

  post '/advices/mark_as_read', to: 'advices#mark_as_read', as: 'advices_mark_as_read'

  root to: 'home#dashboard'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

end
