
.. _create key pair:

Create a public/private key pair
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

A key pair consists of a private and a public key.

#. The private key is stored on the computer(s) you use to access the VSC
   infrastructure and always stays there.
#. The public key is stored on the  VSC systems you want to access, allowing
   to prove your identity through the corresponding private key.
  
How to generate such a key pair depends on your operating system. We
describe the generation of key pairs in the client sections for

- :ref:`Linux<generating keys linux>`,
- :ref:`Windows <generating keys windows>` and
- :ref:`macOS<generating keys macos>` (formerly OS X).

.. toctree::
    :maxdepth: 3
    :numbered:
    :caption: Contents

    generating_keys_with_openssh.rst
    generating_keys_with_putty.rst
    generating_keys_with_openssh_on_os_x.rst