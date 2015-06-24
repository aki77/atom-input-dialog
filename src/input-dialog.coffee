{$, TextEditorView, View}  = require 'atom-space-pen-views'

module.exports =
class InputDialog extends View
  @content: ({prompt} = {}) ->
    @div =>
      @label prompt, class: 'icon', outlet: 'promptText' if prompt
      @subview 'miniEditor', new TextEditorView(mini: true)
      @div class: 'error-message', outlet: 'errorMessage'

  initialize: (options = {}) ->
    {@callback, elementClass, iconClass, defaultText, selectedRange, detached, validate, match} = options

    @element.classList.add(elementClass) if elementClass
    @promptText?.addClass(iconClass) if iconClass

    @miniEditor.on 'blur', @close
    @miniEditor.getModel().onDidChange( =>
      return @showError() unless validate
      @showError(validate(@miniEditor.getModel().getText()))
    )

    if defaultText
      @miniEditor.getModel().setText(defaultText)
      if selectedRange
        @miniEditor.getModel().setSelectedBufferRange(selectedRange)

    if match
      @miniEditor.getModel().onWillInsertText(({cancel, text}) ->
        cancel() unless text.match(match)
      )

    @detached = detached if detached

    atom.commands.add @element,
      'core:confirm': @confirm
      'core:cancel': @close

  storeFocusedElement: ->
    @previouslyFocusedElement = $(':focus')

  restoreFocus: ->
    if @previouslyFocusedElement?.isOnDom()
      @previouslyFocusedElement.focus()
    else
      atom.views.getView(atom.workspace).focus()

  confirm: =>
    text = @miniEditor.getText()
    return unless text.length > 0
    @callback?(text)
    @close()

  close: =>
    miniEditorFocused = @miniEditor.hasFocus()
    panelToDestroy = @panel
    @panel = null
    panelToDestroy?.destroy()
    @restoreFocus() if miniEditorFocused

  attach: ->
    @storeFocusedElement()
    @panel = atom.workspace.addModalPanel(item: @element)
    @miniEditor.focus()
    @miniEditor.getModel().scrollToCursorPosition()

  showError: (message='') ->
    @errorMessage.text(message)
    @flashError() if message
