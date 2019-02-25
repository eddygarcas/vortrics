class Answers
  constructor: ->
    @setup()

  setup: ->
    $("[data-behaviour='answer_link']").on "change", @handleChange
    $("[data-behaviour='text_link']").on "blur", @handleBlur

  handleChange: (e) ->
    @elems = +this.checked;
    @question_id = $(document.activeElement.form.answer_question_id).val()
    @assesment_id = $(document.activeElement.form.answer_assesment_id).val()
    $.ajax(
      url: "/answers/" + this.id
      type: "JSON"
      data: JSON.stringify({"question_id": @question_id, "assesment_id": @assesment_id, "value": @elems})
      method: "PUT"
      contentType: "application/json"
      processData: false
      success: (data)  ->
        if (data['success'] is "true")
          $("[data-behavior='answer_response_" + data['message'] + "']")[0].className += ' has-success';
        else
          $("[data-behavior='answer_response_" + data['message'] + "']")[0].className += ' has-error';
    )

  handleBlur: (e) ->
    @elems = this.value;
    @question_id = $(this.form.answer_question_id).val()
    @assesment_id = $(this.form.answer_assesment_id).val()
    $.ajax(
      url: "/answers/" + this.id
      type: "JSON"
      data: JSON.stringify({"question_id": @question_id, "assesment_id": @assesment_id, "text": @elems})
      method: "PUT"
      contentType: "application/json"
      processData: false
      success: (data)  ->
        if (data['success'] is "true")
          $("[data-behavior='answer_response_" + data['message'] + "']")[0].className += ' has-success';
        else
          $("[data-behavior='answer_response_" + data['message'] + "']")[0].className += ' has-error';
    )

jQuery ->
  new Answers
