---
title: À la Mode - corfu, cape, and completion-preview
date: Thu Jun 27 11:28:20 2024
toc: true
---

## Foreword

Over the last few years there has been an ever greater push towards
making smaller Emacs packages that are more tightly integrated with
the core Emacs ecosystem and work with the grain instead of against
it. In large part this is due to the massive ongoing efforts of the
Emacs maintainers and the community whose enhancements make these
packages easier to write and integrate without needing to reinvent the
wheel.

Some of the changes that have happened include:
 - The creation of ['vertico'](https://github.com/minad/vertico),
   ['orderless'](https://github.com/oantolin/orderless),
   ['consult'](https://github.com/minad/consult),
   ['embark'](https://github.com/oantolin/embark), and
   [''marginalia''](https://github.com/minad/marginalia) as a
   replacement for ['ivy'](https://github.com/abo-abo/swiper),
   ['swiper'](https://github.com/abo-abo/swiper),
   ['counsel'](https://github.com/abo-abo/swiper) and
   ['ivy-rich'](https://github.com/Yevgnen/ivy-rich).
 - The creation of ['corfu'](https://github.com/minad/corfu) and
   ['cape'](https://github.com/minad/cape) as a replacement for
   ['company'](https://company-mode.github.io/).
 - The creation of the builtin `project` package as a replacement for
   ['projectile'](https://github.com/bbatsov/projectile).

Where it makes sense I've made some small efforts to migrate to these
newer leaner packages suites.

Recently I made the move from the
['ivy'](https://github.com/abo-abo/swiper) suite to the
['vertico'](https://github.com/minad/vertico) suite. This was one of
the largest Emacs changes I've made in recent times. Overall it went
well with relatively little friction. My biggest issue however was
when trying to replace my usage of `swiper` with `consult-line`. Even
with the some helpful
[patches](https://www.reddit.com/r/emacs/comments/14aglvm/highlight_multiple_lines_in_consultline/)
I fell short of a complete migration. Thankfully not everything needs
to be black or white, I can use
['swiper'](https://github.com/abo-abo/swiper) where it makes sense and
the ['vertico'](https://github.com/minad/vertico) suite the rest of
the time.

## corfu, cape, and completion-preview-mode

Given the friction I experienced with my migration from the
['ivy'](https://github.com/abo-abo/swiper) suite to the
['vertico'](https://github.com/minad/vertico) suite I was a bit
apprehensive about tackling some of the other migrations. However here
I stand now, without a job and with more free time than ever, thinking
about my Emacs configuration.

I decided to tackle a migration from the excellent
['company'](https://company-mode.github.io/) package to a combination
of ['corfu'](https://github.com/minad/corfu), and
['cape'](https://github.com/minad/cape). Note that I wasn't having any
issues with ['company'](https://company-mode.github.io/) but wanted to
see what new ideas had appeared in the in-buffer completion ecosystem
since I started using ['company'](https://company-mode.github.io/).

When I first started using Emacs 10 years ago
['auto-complete'](https://github.com/auto-complete/auto-complete) was
the elder statesman of completion at point. At the time the new kid on
the block was ['company'](https://company-mode.github.io/). I wanted
to be hip so started using
['company'](https://company-mode.github.io/) and was generally happy
with it. I tweaked it a bit to my liking with
['company-box'](https://github.com/sebastiencs/company-box), and
['esh-autosuggestion'](https://github.com/dieggsy/esh-autosuggest) but
generally it worked well enough that I didn't think about it much over
that time.

### corfu

Setting up ['corfu'](https://github.com/minad/corfu) to my liking was relatively easy:
```lisp
(use-package corfu
  :custom
  ;; Make the popup appear quicker
  (corfu-popupinfo-delay '(0.5 . 0.5))
  ;; Always have the same width
  (corfu-min-width 80)
  (corfu-max-width corfu-min-width)
  (corfu-count 14)
  (corfu-scroll-margin 4)
  ;; Have Corfu wrap around when going up
  (corfu-cycle t)
  (corfu-preselect-first t)
  :bind (:map corfu-map
              ;; Match `corfu-quick-complete' keybinding to `avy-goto-line'
              ("s-j" . corfu-quick-complete))
  :init
  ;; Enable Corfu
  (global-corfu-mode t)
  ;; Enable Corfu history mode to act like `prescient'
  (corfu-history-mode t)
  ;; Allow Corfu to show help text next to suggested completion
  (corfu-popupinfo-mode t))
```

### cape
Setting up new backends via ['cape'](https://github.com/minad/cape)
was equally easy:

```lisp
(use-package cape
  :demand t
  :init
  ;; Add `completion-at-point-functions', used by `completion-at-point'.
  (setq-default completion-at-point-functions
                (append (default-value 'completion-at-point-functions)
                        (list #'cape-dabbrev #'cape-file #'cape-abbrev))))
```

#### cape + hydra

On top of a simple ['cape'](https://github.com/minad/cape)
configuration I realized that sometimes I wanted to call a specific
completion function. For that I added a simple `hydra` which I bind
globally to `M-i`.

```lisp
(defhydra my/cape
  (:color blue :hint nil)
  "
^Complete^
^--------^
_i_ Completion at Point
_d_abbrev
_f_ile
_h_istory
_p_complete
_e_moji
"
  ("i" completion-at-point)
  ("p" (lambda () (interactive) (let ((completion-at-point-functions '(pcomplete-completions-at-point t))) (completion-at-point))))
  ("d" cape-dabbrev)
  ("f" cape-file)
  ("h" cape-history)
  ("e" cape-emoji))
```

#### cape + eshell

I've always found eshell's completion more difficult than other mode's
this is probably because of its usage of `pcomplete` and how it
overrides any globally defined `completion-at-point-functions`. In a
sort of arms race I "fix" this by once again overriding
`completion-at-point-functions`. If I'd like to see the `pcomplete`
completions I now explicitly demand them via my hydra, `M-i p`.

```lisp
(use-package em-cmpl
  :ensure nil
  :config
  (bind-key "C-M-i" nil eshell-cmpl-mode-map)
  (defun my/em-cmpl-mode-hook ()
    (setq completion-at-point-functions
          (list #'cape-history #'cape-file #'cape-dabbrev)))
  (add-hook 'eshell-cmpl-mode-hook #my/em-cmpl-mode-hook))
```

### completion-preview-mode

The last bit that needed replacing was my usage of
['esh-autosuggestion'](https://github.com/dieggsy/esh-autosuggest). Essentially
this package would display the top completion candidate and let you
select it.

Thankfully the excellent builtin `completion-preview` package was
added in Emacs 30.1 by Eshel Yaron which gives me just this.

```lisp
(use-package completion-preview
  :ensure nil
  :bind (:map completion-preview-active-mode-map
              ("M-f" . #'completion-preview-insert-word)
              ("C-M-f" . #'completion-preview-insert-sexp))
  :custom
  (completion-preview-minimum-symbol-length 2)
  :init
  (global-completion-preview-mode))
```

#### completion-preview-mode enhancements

One thing I'd like to add is some new additions to
`completion-preview`. Having used `github-copilot` a bit at my last
job I am used to partially completing the "top" candidate with
`M-f`. With careful code review and help from Eshel I've added two new
commands to `completion-preview`: `completion-preview-insert-word`
`completion-preview-insert-sexp`. If you use the latest version of
Emacs `master` you should have access to these functions as well. I
hope they help.

## Future work

Maybe going forward I'll migrate from
['projectile'](https://github.com/bbatsov/projectile) to the builtin
`project` or from `straight` to `elpaca` but as they say "If it ain't
broke, don't fix it, unless it sounds like a good learning
experience".
