#Developer notes
##Ruby on Rails
###Upgrade Ruby
```
$ curl -sSL https://get.rvm.io | bash -s stable
$ rvm list known
# MRI Rubies
[ruby-]2.1[.10]
[ruby-]2.2[.10]
[ruby-]2.3[.8]
[ruby-]2.4[.5]
[ruby-]2.5[.3]
[ruby-]2.6[.0]
$ rvm install ruby-2.4.0
$ rvm use ruby-2.4.0 --default
```
###Update Bundler
```
$ gem update --system
$ update bundler
$ gem install bundler
```
Update Gemfile.lock in your project
```
$ bundler update --bundler
```

### Console
Run on development mode
```
RAILS_ENV=development bundle exec rails c
```
### Rails scaffold
Diferent types of scaffold creation
```
railg g scaffold team name:string max_capacity:integer current_capacity:integer 
rails g scaffold sprint name:string stories:integer bugs:integer closed_points:integer ramaining:integer team:references
rails g scaffold components name:string points:integer sprint:references
```
Create a mono transitive assisiation
````
rails g model Student name:string
rails g model Tutor name:string
rails g model Klass subject:string student:references tutor:references
````
and the result should look like thus
```
class Student < ApplicationRecord
  has_many :klasses
  has_many :tutors, through: :klasses
end
class Tutor < ApplicationRecord
  has_many :klasses
  has_many :students, through: :klasses
end
class Klass < ApplicationRecord
  belongs_to :student
  belongs_to :tutor
end
```
### Rake migration and database
##### Delete a migration file safely
```
rails d migration MigrationNameOptions
```

##### Rollback last migration:
```
rake db:rollback STEP=1
```
Drop and create DB all over again
````
 rake db:drop db:create db:migrate db:seed
````

##Git
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
Delete a remote branch
````
#Remote:
$ git push origin --delete <branch> # Git version 1.7.0 or newer
#Local:
$ git branch --delete <branch>
````
Get changes from master into a branch
```
$ git rebase master
```
Git push a branch into remote master
```
$ git push <remote> <local branch name>:<remote branch to push into>
```

##Heroku
Run heroku commands locally, i.e. rails db:migrate
```
$ heroku run rails db:migrate
```
```
$ heroku logs -t
```
## Vue.js
### Install (macos)
````
$ brew search nodejs
==> Formulae
node.js                                                              nodejs
$ brew install nodejs
````
Check out node.js version
```
$ node -v
```
Update node.js
```
$ brew update
$ brew upgrade nodejs
```
Install yarn
```
$ brew install yarn
```
Install webpacker
```
# Gemfile
gem 'webpacker', '~> 4.x'
```
```
$ bundle
$ bundle exec rails webpacker:install
$ rails webpacker:install:vue
```