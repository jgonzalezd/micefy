root = exports ? this

questionTemplate = _.template(
  """
    <div>
      <%= get("content") %>
    </div>
  """
)
root.questionTemplate = questionTemplate
