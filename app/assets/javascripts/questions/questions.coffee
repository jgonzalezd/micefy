root = exports ? this

class Questions extends Backbone.Collection
  url: "/questions"
  model: Question
root.Questions = Questions
