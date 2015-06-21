# atom-input-dialog

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
