Vim surround plugin
===================
Yet another surround plugin for Vim.

You can fully customize the surroundings.

Mappings are derived from other surround plugin:
`tpope/vim-surround <https://github.com/tpope/vim-surround>`_,
`kana/vim-surround <https://github.com/kana/vim-surround>`_.

Install
-------
First, make sure that you uninstall other surround plugins.

And you can install with your favorite method.

If you haven't have one, you can use Vim's built-in plugin system.
See `:help packages <https://vimhelp.org/repeat.txt.html#packages>`_.

.. code-block:: sh

   git clone git://github.com/matsuhav/vim-surround ~/.vim/pack/manual/start/

Examples
--------
-  `ysiw<Space><Space>` will surround a word with spaces.
-  `ysiwffunc` will surround a word with a function named func.
-  `yssta>` will surround a line with <a> tag.
-  `dsf` will delete a surrounding function.
-  `2dsf` will delete the second outer surrounding function.
-  `dsl` will delete a surrounding tex begin-end environment.

See help for more information and settings.

The `.` command will work if you install
`repeat.vim <https://github.com/tpope/vim-repeat>`_.

License
-------
Distributed under the same terms as Vim itself.
See `:help license <https://vimhelp.org/uganda.txt.html>`_.
