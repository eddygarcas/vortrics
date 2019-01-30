# Developer notes

##Ruby on Rails

###Console
#####Run on development mode
```
RAILS_ENV=development bundle exec rails c
```
###Rails scaffold
```
railg g scaffold team name:string max_capacity:integer current_capacity:integer 
rails g scaffold sprint name:string stories:integer bugs:integer closed_points:integer ramaining:integer team:references
rails g scaffold components name:string points:integer sprint:references
```

###Rails migration
##### Delete a migration file safely
```
rails d migration MigrationNameOptions
```

##### Rollback last migration:
```
rake db:rollback STEP=1
```

###Git
```
$ git show-ref 
#will display a list of branches

$ git branch -m HEAD LocalHead 
# Rename a branch

$ git checkout master
# Checkout form master branch

$ git branch -D LocalHead 
# Force to delete a branch
```
Git remove history 
````
-- Remove the history from 
rm -rf .git

-- recreate the repos from the current content only
git init
git add .
git commit -m "Initial commit"

-- push to the github remote repos ensuring you overwrite history
git remote add origin git@github.com:<YOUR ACCOUNT>/<YOUR REPOS>.git
git push -u --force origin master
````

Git delete a recent unpushed file (https://help.github.com/articles/removing-files-from-a-repository-s-history/)
````
$ git rm --cached giant_file
# Stage our giant file for removal, but leave it on disk

$ git commit --amend -CHEAD
# Amend the previous commit with your change
# Simply making a new commit won't work, as you need
# to remove the file from the unpushed history as well

$ git push
# Push our rewritten, smaller commit
````
###Heroku
Run heroku commands locally, i.e. rails db:migrate
```
$ heroku run rails db:migrate
```
```
$ heroku logs -t
```
