Vim surround plugin
===================
Yet another surround plugin for Vim.

You can fully customize the surroundings.

Mappings are partly derived from other surround plugin:
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
.. code-block: vim

   let g:surround_dict = {'U': 'https://\r/',
                        \ 'Vi': '\n\1m is \1 iMproved\n\r',
                        \ }

See help for more information.

The `.` command will work if you install
`repeat.vim <https://github.com/tpope/vim-repeat>`_.

License
-------
Distributed under the same terms as Vim itself.
See `:help license <https://vimhelp.org/uganda.txt.html>`_.
