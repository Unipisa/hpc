.. _scp and sftp:

Data transfer with scp/sftp
===========================

Prerequisite: OpenSSH
---------------------

``scp`` (Secure copy) and ``sftp`` (Secure FTP) are part of the OpenSSH
distribution.

See the page on :ref:`generating keys <generating keys linux>`.

Using scp
---------

How to copy a file?
~~~~~~~~~~~~~~~~~~~

Files can be transferred with the ``scp,`` command,  which is similar to
the standard ``cp`` shell command to copy files.  However, ``scp`` can copy
to and from remote systems that runs an ``sshd`` daemon.

For example, to copy the (local) file ``local_file.txt`` to your home
directory on the cluster (where ``<unipi-loginnode>`` is a loginnode), use:

::

   $ scp local_file.txt <unipi-account>@<unipi-loginnode>:

Likewise, to copy the remote file ``remote_file.txt`` from your home
directory on the cluster to your local computer, use:

::

   $ scp <unipi-account>@<unipi-loginnode>:remote_file.txt .

.. note::

   The colon in the remote path is required!

Suppose you want to copy multiple files ``data_<id>.txt`` from the current
working directory on your local system to a directory called `inputs` in
your data directory on a unipi system, you can use globbing, just as you
would for ``cp``.

::

   $ scp data_*.txt unipi50005@login.hpc.kuleuven.be:/data/leuven/500/unipi50005/inputs

.. warning::

   Although it might be tempting to use the ``$unipi_DATA`` environment variable,
   this will not work.  The variable will be expanded on your local system,
   where it is not defined, resulting in a copy to a directory `inputs` in
   your unipi home directory.


Copying directories
~~~~~~~~~~~~~~~~~~~

Similar to ``cp`` copying a directory can be done using the ``-r`` flag, e.g.,

::

   $ scp -r inputs/ unipi50005@login.hpc.kuleuven.be:/data/leuven/500/unipi50005/

This will copy the directory (and all of its contents) from your local system
to your data directory on the unipi remote system.


Using sftp
----------

``sftp`` is an equivalent of the ``ftp`` command, but it uses the
secure SSH protocol to connect to the clusters.

One easy way of starting a sftp session is

::

   $ sftp <unipi-account>@<unipi-loginnode>

You can now transfer files to and from the remote system `<unipi-loginnode>``.

Some useful ``sftp`` commands are listed in the table below.

+------------------------+--------+-------+
| operation              | remote | local |
+========================+========+=======+
| change directory       | cd     | lcd   |
+------------------------+--------+-------+
| list directory content | ls     | lls   |
+------------------------+--------+-------+
| copy file from         | get    | put   |
+------------------------+--------+-------+
| glob copy from         | mget   | mput  |
+------------------------+--------+-------+
| quit                   |       bye      |
+------------------------+--------+-------+

.. include:: /date/date.rst