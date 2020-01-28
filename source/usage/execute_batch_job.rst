******************************
Execute a batch PBS Job
****************************** 

TODO: rivedere pesantemente


An HPC cluster is a multi-user system.  This implies that your computations
run on a part of the cluster that will be temporarily reserved for you by
the scheduler.

.. warning::

   Do not run computationally intensive tasks on the login nodes! These
   nodes are shared among all active users, so putting a heavy load on those
   nodes will annoy other users.

Although you can :ref:`work interactively <interactive jobs>` on an HPC system,
most computations are performed in batch mode.

The workflow is straightforward:

#. Create a job script.
#. Submit it as a job to the scheduler.
#. Wait for the computation to run and finish.


Job script
----------

A job script is essentially a Bash script, augmented with information for the
scheduler.  As an example, consider a file ``hello_world.pbs`` as below.

.. code-block:: bash
   :linenos:

   #!/usr/bin/env bash

   #PBS -l nodes=1:ppn=1
   #PBS -l walltime=00:05:00
   #PBS -l pmem=1gb

   cd $PBS_O_WORKDIR

   module purge
   module load Python/3.7.2-foss-2018a

   python hello_world.py


We discuss this script line by line.

- Line 1 is a she-bang that indicates that this is a Bash script.
- Lines 3-5 inform the scheduler about the resources required by this job.

  - It requires a single node (``nodes=1``), and a single core (``ppn=1``) on
    that node.
  - It will run for at most 5 minutes (``walltime=00:05:00``).
  - It will use at most 1 GB of RAM (``pmem=1gb``).

- Line 7 changes the working directory to the directory in which the job will
  be submitted (that will be the value of the ``$PBS_O_WORKDIR`` environment
  variable when the job runs).
- Lines 9 and 10 set up the environment by :ref:`loading the appropriate modules 
  <module system basics>`.
- Line 12 performs the actual computation, i.e., running a Python script.

.. warning::

   When running on KU Leuven/UHasselt and Tier-1 infrastructure make sure to specify
   a credit account as part of your job script, if not, your job will not
   run.

   ::

      #PBS -A lp_example

   For more information, see :ref:`credit system basics<credit system basics>`.

Every job script has the same basic structure.

.. note::

   Although you can use any file name extension you want, it is good practice
   to use ``.pbs`` since that allows support staff to easily identify your
   job script.

More information is available on

- :ref:`specifying job resources <resource specification>`,
- :ref:`specifying job names, output files and notifications
  <specifying output files and notifications>`,
- using the :ref:`credit system <credit system basics>` (KU Leuven/UHasselt
  infrastructure and Tier-1 only),
- using the :ref:`module system <module system basics>`.


Submitting and monitoring a job
-------------------------------

Once you have created your job script, and transferred all required input data
if necessary, you can submit your job to the scheduler

::

   $ qsub hello_world.pbs
   205814.leibniz

The ``qsub`` returns a job ID, an unique identifier that you can use to manage
your job.  Only the number, i.e., ``205814`` is significant.

Once submitted, you can monitor the status of your job using the ``qstat`` command.

::

   $ qstat
   Job ID                    Name             User            Time Use S Queue
   ------------------------- ---------------- --------------- -------- - -----
   205814.leibniz            hello_world.pbs  vsc30140               0 Q q1h

The status of your job is given in the ``S`` column.  The most common values are
given below.

+--------+------------------------------------------------------+
| status | meaning                                              |
+========+======================================================+
| Q      | job is *queued*, i.e., waiting to be executed        |
+--------+------------------------------------------------------+
| R      | job is *running*                                     |
+--------+------------------------------------------------------+
| C      | job is *completed*, i.e., finished.                  |
+--------+------------------------------------------------------+

More information is available on

.. toctree::
   :maxdepth: 3
   
   submitting and monitoring your jobs <submitting_and_managing_jobs_with_torque_and_moab>


Job output
----------

By default, the output of your job is saved to two files.

``<job_name>.o<jobid>``
   This file contains all text written to standard output, as well as some
   information about your job.
``<job_name>.e<jobid>``
   This file contains all text written to standard error, if any.  If your job fails,
   or doesn't produce the expected output, this is the first place to look.

For instance, for the running example, the output file would be
``hello_world.pbs.o205814`` and contains

.. code-block::
   :linenos:

   ===== start of prologue =====
   Date : Mon Aug  5 14:50:28 CEST 2019
   Job ID : 205814
   Job Name : hello_world.pbs
   User ID : vsc30140
   Group ID : vsc30140
   Queue Name : q1h
   Resource List : walltime=00:05:00,nodes=1:ppn=1,neednodes=1:ppn=1
   ===== end of prologue =======
   
   hello world!
   
   ===== start of epilogue =====
   Date : Mon Aug  5 14:50:29 CEST 2019
   Session ID : 21768
   Resources Used : cput=00:00:00,vmem=0kb,walltime=00:00:02,mem=0kb,energy_used=0
   Allocated Nodes : r3c08cn1.leibniz 
   Job Exit Code : 0
   ===== end of epilogue =======

Lines 1 through 10 are written by the prologue, i.e., the administrative script that
runs before your job script.  Similarly, lines 12 though 19 are written by the
epilogue, i.e., the administrative script that runs after your job script.

Line 11 is the actual output of your job script.

.. note::

   The format of the output file differs slightly from cluster to cluster, although
   the overall structure is the same.


Troubleshooting
---------------

.. toctree::
   :maxdepth: 2

   Why doesn't my job start immediately? <why_doesn_t_my_job_start>
   Why does my job fail after a successful start? <what_if_jobs_fail_after_starting_successfully>


Advanced topics
---------------

-  :ref:`monitoring memory and cpu`, which helps to find the
   right parameters to improve your specification of the job requirements.
-  :ref:`worker framework`: To manage lots of small jobs on a cluster. The
   cluster scheduler isn't
   meant to deal with tons of small jobs. Those create a lot of
   overhead, so it is better to bundle those jobs in larger sets.
-  The :ref:`checkpointing framework` can be used to run programs that take
   longer than the maximum time
   allowed by the queue. It can break a long job in shorter jobs, saving
   the state at the end to automatically start the next job from the
   point where the previous job was interrupted.


.. _interactive jobs:

Starting interactive jobs
~~~~~~~~~~~~~~~~~~~~~~~~~

Though our clusters are mainly meant to be used for batch jobs, there
are some facilities for interactive work:

-  The login nodes can be used for light interactive work. They can
   typically run the same software as the compute nodes. Some sites also
   have special interactive nodes for special tasks, e.g., scientific
   data visualization. See the ":ref:`hardware`" section
   where each site documents what is available.
   Examples of work that can be done on the login nodes :

   - running a GUI program that generates the input files for your
     simulation,
   - a not too long compile,
   - a quick and not very resource intensive visualization.

   We have set limits on the compute time a program can use on the
   login nodes.

-  It is also possible to request one or more compute nodes for
   interactive work. This is also done through the ``qsub`` command.
   Interactive use of nodes is mostly meant for

   - debugging,
   - for large compiles, or
   - larger visualizations on clusters that don't have dedicated nodes for
     visualization.

To start an interactive job, use ``qsub``'s ``-I`` option.  You would
typically also add several ``-l`` options to specify for how long
you need the node and the amount of resources that you need. For instance,
to use a node with 20 cores interactively for 2 hours, you can use the
following command::

   qsub -I -l walltime=2:00:00 -l nodes=1:ppn=20

``qsub`` will block until it gets a node and then you get the command
prompt for that node. If the wait is too long however, ``qsub`` will
return with an error message and you'll need to repeat the command.

If you want to run **graphical user interface programs** (using X) in your
interactive job, you have to add the ``-X`` option to the above command.
This will set up the forwarding of X traffic to the login node, and
ultimately to your terminal if you have set up the connection to the login
node properly for X support.

.. note::

   - Please be reasonable when requesting interactive resources. On
     some clusters, a short walltime will give you a higher priority, and on
     most clusters a request for a multi-day interactive session will fail
     simply because the cluster cannot give you such a node before the
     time-out of ``qsub`` kicks in.

   - Please act responsibly, interactive jobs are by definition inefficient:
     the systems are mostly idling while you type.


Viewing your jobs in the queue
------------------------------

Two commands can be used to show your jobs in the queue:

-  ``qstat`` show the queue from the resource manager's perspective. It
   doesn't know about priorities, only about requested resources and the
   state of your job: Still idle and waiting for resources, running,
   completed, ...
-  ``showq`` shows the queue from the scheduler's perspective, taking
   priorities and policies into account.



.. _qstat:

qstat
~~~~~

On the VSC clusters, users will only receive a part of the information
that ``qstat`` offers. To protect the users' privacy, output is always
restricted to the user's own jobs.

To see your jobs in the queue, enter::

   $ qstat

This will give you an overview of all jobs including their status, possible
values are listed in the table below.

+--------+------------------------------------------------------+
| status | meaning                                              |
+========+======================================================+
| Q      | job is *queued*, i.e., waiting to be executed        |
+--------+------------------------------------------------------+
| S      | job is *starting*, i.e., its prologue is executed    |
+--------+------------------------------------------------------+
| R      | job is *running*                                     |
+--------+------------------------------------------------------+
| E      | job is *exiting*, i.e., its epilogue is executed     |
+--------+------------------------------------------------------+
| C      | job is *completed*, i.e., finished.                  |
+--------+------------------------------------------------------+
| H      | job has a *hold* in place                            |
+--------+------------------------------------------------------+

Several command line options can be specified to modify the output of
``qstat``:

-  ``-i`` will show you the resources the jobs require.
-  ``-n`` or ``-n1`` will also show you the nodes allocated to each running job.


.. _showq:

showq
~~~~~

The ``showq`` command will show you information about the queue from the
scheduler's perspective. Jobs are subdivided in three categories:

-  Active jobs are actually running, started or terminated.
-  Eligible jobs are queued and considered eligible for scheduling.
-  Blocked jobs are ineligible to run or to be queued for scheduling.
 
The ``showq`` command will split its output according to the three major
categories. Active jobs are sorted according to their expected end time
while eligible jobs are sorted according to their current priority.

There are multiple reasons why a job might be blocked, indicated by the state
value below:

Idle
   Job violates a fairness policy, i.e., you have used too many resources lately.
   Use diagnose ``-q`` for more information.
UserHold
   A user hold is in place.  This may be caused by job dependencies.
SystemHold
   An administrative or system hold is in place.  The job will not start until
   that hold is released.
BatchHold
   A scheduler batch hold is in place, used when the job cannot be run because

   - the requested resources are not available in the system, or
   - because the resource manager has repeatedly failed in attempts to start the
     job.  This typically indicates a problem with some nodes of the cluster,
     so you may want to contact user support.
Deferred
   A scheduler defer hold is in place (a temporary hold used when a job has been
   unable to start after a specified number of attempts. This hold is automatically
   removed after a short period of time).  
NotQueued
   Job is in the resource manager state NQ (indicating the job's controlling
   scheduling daemon in unavailable).

If your job is blocked, you may want to run the :ref:`checkjob <checkjob>` command
to find out why.

There are some useful options for ``showq``:

- ``-r`` will show you the running jobs only, but will also give
   more information about these jobs, including an estimate about how
   efficiently they are using the CPU.
- ``-i`` will give you more information about your eligible jobs.
- ``-p <partition>`` will only show jobs running in the specified partition.


.. _queues:

A note on queues
~~~~~~~~~~~~~~~~

Both ``qstat`` and ``showq`` can show you the name of the queue (``qstat``) or
class (``showq``) which in most cases is actually the same as the
queue.

All VSC clusters have multiple queues that are used to define policies.
E.g., users may be allowed to have many short jobs running simultaneously,
but may be limited to a few multi-day jobs to avoid long-time
monopolization of a cluster by a single user.

This would typically be implemented by having separate queues with specific policies for
short and long jobs. When you submit a job, ``qsub`` will put the job
in a particular queue based on the resources requested automatically.

.. warning::

   The ``qsub`` command does allow to specify the queue to use, but unless
   explicitly instructed to do so by user support, we  advise strongly against the use of this
   option.
  
   Putting the job in the wrong queue may actually result in your
   job being refused by the resource manager, and we may also chose to
   change the available queues on a system to implement new policies.


.. _detailed job info:

Getting detailed information about a job
----------------------------------------

qstat
~~~~~

To get detailed information on a single job, add the job ID as argument and
use the ``-f`` or ``-f1`` option::

   $ qstat -f <jobid>

The ``-n`` or ``-n1`` will just show you the nodes allocated to each running job in
addition to regular output.


.. _checkjob:

checkjob
~~~~~~~~

The ``checkjob`` command also provides details about a job, but from
the perspective of the scheduler, so  that you get different information.

The command below will produce information about the job with jobid 323323::

   $ checkjob 323323

Adding the ``-v`` option (for verbose) gives you even more information::

   $ checkjob -v 323323

For a running job, checkjob will give you an overview of the allocated
resources and the wall time consumed so far. For blocked jobs, the end
of the output typically contains clues about why a job is blocked.


.. _qdel:

Deleting a queued or running job: qdel
--------------------------------------

This is easily done with ``qdel``, e.g., the following command will delete the
job with ID 323323::

   $ qdel 323323

If the job is already running, the processes will be killed and the resources
will be returned to the scheduler for another job.


.. _showstart:

Getting a start time estimate for your job: showstart
-----------------------------------------------------

This is a very simple tool that will tell you, based on the current
status of the cluster, when your job is scheduled to start::

   $ showstart 20030021
   job 20030021 requires 896 procs for 1:00:00
   Earliest start in       5:20:52:52 on Tue Mar 24 07:36:36
   Earliest completion in  5:21:52:52 on Tue Mar 24 08:36:36
   Best Partition: DEFAULT

.. note::

   This is only an estimate, based on the jobs that are currently running or
   queued and the walltime that users gave for these jobs.

   - Jobs may always end sooner than requested, so your job may start sooner.
   - On the other hand, jobs with a higher priority may also enter the queue and
     delay the start of your job.


   .. _showbf:

Checking free resources for a short job: showbf
-----------------------------------------------

When the scheduler performs its task, there is bound to be
some gaps between jobs on a node. These gaps can be back filled with
small jobs. To get an overview of these gaps, you can execute the
command ``showbf``::

   $ showbf
   backfill window (user: 'vsc30001' group: 'vsc30001' partition: ALL) Wed Mar 18 10:31:02
   323 procs available for      21:04:59
   136 procs available for   13:19:28:58

To check whether a job can run in a specific partition, add the ``-p <partition>`` option.

.. note::

   There is however no guarantee that if you submit a job that would fit in
   the available resources, it will also run immediately. Another user
   might be doing the same thing at the same time, or you may simply be
   blocked from running more jobs because you already have too many jobs
   running or have made heavy use of the cluster recently.