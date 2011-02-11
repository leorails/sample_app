require 'faker'

namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    make_users
    make_microposts
    make_relationships
  end
end

def make_users
  admin = User.create!(:name => "Leo Ping",
                       :email => "leo.ping@sage.com",
                       :password => "foobar",
                       :password_confirmation => "foobar")
  admin.toggle!(:admin)

  admin = User.create!(:name => "Eric Martin",
                       :email => "eric.martin@sage.com",
                       :password => "foobar",
                       :password_confirmation => "foobar")

  admin = User.create!(:name => "Brian Wong",
                       :email => "brian.wong@sage.com",
                       :password => "foobar",
                       :password_confirmation => "foobar")

  admin = User.create!(:name => "Alec Loo",
                       :email => "alec.loo@sage.com",
                       :password => "foobar",
                       :password_confirmation => "foobar")

  admin = User.create!(:name => "Bryan Belyk",
                       :email => "bryan.belyk@sage.com",
                       :password => "foobar",
                       :password_confirmation => "foobar")

  99.times do |n|
    name  = Faker::Name.name
    email = "example-#{n+1}@railstutorial.org"
    password  = "password"
    User.create!(:name => name,
                 :email => email,
                 :password => password,
                 :password_confirmation => password)
  end
end

def make_microposts
  # make sample microposts for the first 6 users
  User.all(:limit => 6).each do |user|
    50.times do
      user.microposts.create!(:content => Faker::Lorem.sentence(5))
    end
  end
end

def make_relationships
  users = User.all
  leo  = users.first
  following = users[1..10]
  followers = users[2..30]
  following.each { |followed| leo.follow!(followed) }
  followers.each { |follower| follower.follow!(leo) }
end









