# Features

## Lightbox

Image shortcode allows to turn on
[baguetteBox.js](https://feimosi.github.io/baguetteBox.js/) for given
image.

## Syntax highlighting.

Built-in Chroma Native color theme.

## Auto-hide/show header

This theme uses [headroom.js](http://wicky.nillia.ms/headroom.js/)
script.

## Page scroll indicator

Displays progress bar on the top of the page when user scrolls the
page.

## Shortcodes

This theme includes additional shortcodes.

### Image

All images should be stored in `content/images` directory. Each subdirectory should contain `_index.md` file with this content:

```
---
title: Media Folder
---

```

Insert responsive image with title:

`{{< image src="media/image-1.jpg" title="Photo by Ales Krivec on Unsplash" >}}`

Full page width image:

`{{< image src="media/image-1.jpg" title="Photo by Ales Krivec on Unsplash" full="true">}}`

Lightbox:

`{{< image src="media/image-1.jpg" lightbox="true" >}}`

Rounded corners:

`{{< image src="media/image-1.jpg" round="50" >}}`

Insert image without resizing (the same image for all devices/resolutions).

`{{< image src="media/image-1.jpg" resize="false" >}}`

### Speaker Deck

`{{< speakerdeck 50021f75cf1db900020005e7 >}}`

### Video

`{{< video src="media/video.mp4" >}}`

### Responsive Vimeo

`{{< vimeo 265143954 >}}`

### Responsive Youtube

`{{< vimeo 265143954 >}}`
