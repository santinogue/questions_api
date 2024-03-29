# NOTES

Redis is used for the tenant's throttle logic. You must install redis-server in your machine.

The approach selected to track the daily usage of a tenant uses Redis cache.

Another possible approach would have been to model the API requests, on their own table, and associate them with the tenants.

The cache approach was selected to enhance the response time of the requests.


# TODO

1.  Add pagination to questions#index (For questions and answers.) Consider Kaminari gem.
2.  Versioning of API (Routes/Controllers/Serializers), consider the following approach https://chriskottom.com/blog/2017/04/versioning-a-rails-api/
3.  Add an index to Tenant api_key column to speed up requests.
4.  Comment code using something like YARD.
5.  Improve Dashboard page design. Right now is really really basic.

# BacklotCars Rails Engineer Candidate Interview Project

Thanks for taking the time to complete this exercise. We're excited that you're considering joining our amazing team.

This Rails application is a basic skeleton of an app that serves an API about questions and answers. It already includes 4 basic models:

1.  Question
2.  Answer
3.  User
4.  Tenant

A Question can have one or more answers, and can be shareable. Every Answer belongs to one question. Each Question has an asker (User), and each Answer has a provider (User).

A Tenant is a consumer of the API you are going to write. A db/seeds.rb file is included to preload the database with test data when you setup the DB.

## You need to accomplish the following tasks:

*   Add a RESTful, read-only API to allow consumers to retrieve Questions with Answers as JSON (no need to retrieve Answers on their own). The response should include Answers inside their Question as well as include the id and name of the Question and Answer users.
*   Don't return non-shareable Questions in the API response.
*   Require every API request to include a valid Tenant API key, and return an HTTP code of your choice if the request does not include a valid key.
*   Track API request counts per Tenant.
*   Add an HTML dashboard page as the root URL that shows the total number of Users, Questions, and Answers in the system, as well as Tenant API request counts for all Tenants.  Style it enough to not assault a viewer's sensibilities.
*   Add tests around the code you write as you deem appropriate. Assume that the API cannot be changed once it's released and test accordingly.
*   You are welcome to add any models or other code you think you need, as well as any gems.

## Extra credit features you might consider:

*   Allow adding a query parameter to the API request to select only Questions that contain the query term(s).  Return an appropriate HTML status code if no results are found.
*   Add a piece of middleware to throttle API requests on a per-Tenant basis. After the first 100 requests per day, throttle to 1 request per 10 seconds.

## Project Setup

Clone this repo locally, and from the top-level directory run:

`bundle install`

`bundle exec rake db:setup`

To make sure it's all working,

`rails s`

You should see this same information.

## Submitting your project

Share a link to your repository so we can review your commit history and final solution.  If you need to add any additional instructions to the README please put them at the very top of that file and mention.  Expect to discuss your design decisions during the interview.
