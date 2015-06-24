# atom-input-dialog [![Build Status](https://travis-ci.org/aki77/atom-input-dialog.svg?branch=master)](https://travis-ci.org/aki77/atom-input-dialog)

## InputDialog

### Example

```coffeescript
InputDialog = require '@aki77/atom-input-dialog'

dialog = new InputDialog({
  callback: (text) ->
    console.log text
})
dialog.attach()
```

### Constructor Params

Pass an optional params object to the constructor with the following keys:

* `callback`
* `elementClass`
* `iconClass`
* `defaultText`
* `selectedRange`
* `prompt`
* `detached`
* `validate`
* `match`
