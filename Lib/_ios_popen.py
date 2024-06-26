"""
Support for running Python scripts with 'subprocess.Popen' when the program is 'sys.executable'.
"""

from outputredirector import Reader
import subprocess
import threading
import os
import io
import sys
import shlex
import traceback


def close():
    pass

sys.stdin.close = close


class OutputReader(Reader):

    def __init__(self):
        self.output = ""

    def write(self, txt):
        if txt.__class__ is str:
            self.output += txt
        elif txt.__class__ is bytes:
            text = txt.decode()
            self.write(text)


_Popen = subprocess.Popen

class Popen(_Popen):

    def __init__(self, args, bufsize=-1, executable=None,
                 stdin=None, stdout=None, stderr=None,
                 preexec_fn=None, close_fds=True,
                 shell=False, cwd=None, env=None, universal_newlines=None,
                 startupinfo=None, creationflags=0,
                 restore_signals=True, start_new_session=False,
                 pass_fds=(), *, user=None, group=None, extra_groups=None,
                 encoding=None, errors=None, text=None, umask=-1, pipesize=-1):
        
        sys = __import__("sys")

        if isinstance(args, str):
            args = shlex.join(args)
        args = list(args)

        _args = args

        if (len(args) > 0 and (args[0] == sys.executable or args[0] == "Pyto" or args[0] == "python")) or (executable == sys.executable or executable == "Pyto" or executable == "python"):

            if executable == sys.executable and args[0] != sys.executable:
                args.insert(0, sys.executable)
            
            args.pop(0)
            args.insert(0, "python")

            self.args = args

            _stdin = sys.stdin
            _stdout = sys.stdout
            _stderr = sys.stderr
            _argv = sys.argv
            _env = os.environ
            _cwd = os.getcwd()

            if stdin is None or isinstance(stdin, int):
                stdin = sys.stdin
            
            if isinstance(stdout, int):
                stdout = OutputReader()

            if isinstance(stderr, int):
                stderr = OutputReader()

            if stdout is None:
                stdout = sys.stdout

            if stderr is None:
                stderr = sys.stderr
            
            if env is None:
                env = os.environ

            sys.stdin = stdin
            sys.stdout = stdout
            sys.stderr = stderr
            sys.argv = args
            os.environ = env
            if cwd is not None:
                os.chdir(cwd)

            self.args = _args
            self.stdin = stdin
            self.stdout = stdout
            self.stderr = stderr
            self.pid = None
            self.returncode = None
            self.encoding = encoding
            self.errors = errors
            self.pipesize = pipesize
            self._communication_started = False
            self._waitpid_lock = threading.Lock()
            self._input = None

            self.text = encoding or errors or text or universal_newlines

            try:
                from _shell.bin import python
                python.main()
                self.returncode = 0
            except SystemExit as e:
                if e.code is not None and isinstance(e.code, int):
                    self.returncode = e.code
                else:
                    self.returncode = 0
            except Exception as e:
                self.returncode = 1
            finally:
                sys.stdin = _stdin
                sys.stdout = _stdout
                sys.stderr = _stderr
                sys.argv = _argv
                os.environ = _env
                os.chdir(_cwd)

                self.stdout, self.stderr = self.communicate()
                if isinstance(self.stdout, str):
                    self.stdout = io.StringIO(self.stdout)
                elif isinstance(self.stdout, bytes):
                    self.stdout = io.BytesIO(self.stdout)
                
                if isinstance(self.stderr, str):
                    self.stderr = io.StringIO(self.stderr)
                elif isinstance(self.stderr, bytes):
                    self.stderr = io.BytesIO(self.stderr)
        elif len(args) > 0 and args[0] == "uname":
            new_args = list(args)
            new_args.insert(0, sys.executable)
            new_args.insert(1, "-m")
            self.__init__(args=new_args, bufsize=bufsize, executable=executable, 
                          stdin=stdin, stdout=stdout, stderr=stderr, 
                          preexec_fn=preexec_fn, close_fds=close_fds, 
                          shell=shell, cwd=cwd, env=env, universal_newlines=universal_newlines, 
                          startupinfo=startupinfo, creationflags=creationflags,
                          restore_signals=restore_signals, start_new_session=start_new_session,
                          pass_fds=pass_fds, user=user, group=group, extra_groups=extra_groups,
                          encoding=encoding, errors=errors, text=text, umask=umask, pipesize=pipesize)
        else:
            new_args = list(args)
            new_args.insert(0, sys.executable)
            new_args.insert(1, "-m")
            new_args.insert(2, "_system")
            self.__init__(args=new_args, bufsize=bufsize, executable=executable, 
                          stdin=stdin, stdout=stdout, stderr=stderr, 
                          preexec_fn=preexec_fn, close_fds=close_fds, 
                          shell=shell, cwd=cwd, env=env, universal_newlines=universal_newlines, 
                          startupinfo=startupinfo, creationflags=creationflags,
                          restore_signals=restore_signals, start_new_session=start_new_session,
                          pass_fds=pass_fds, user=user, group=group, extra_groups=extra_groups,
                          encoding=encoding, errors=errors, text=text, umask=umask, pipesize=pipesize)
    
    def kill(self):
        pass

    def terminate(self):
        pass

    def wait(self, timeout=None):
        return self.returncode

    def communicate(self, input=None, timeout=None):
        if isinstance(self.stdout, OutputReader):
            if self.text:
                stdout = self.stdout.output
            else:
                stdout = self.stdout.output.encode("utf-8")
        elif isinstance(self.stdout, str):
            if self.text:
                stdout = self.stdout
            else:
                stdout = self.stdout.encode("utf-8")
        else:
            self.stdout.seek(0)
            try:
                stdout = self.stdout.read()
            except io.UnsupportedOperation:
                stdout = ""
            self.stdout.seek(0)

        if isinstance(self.stderr, OutputReader):
            if self.text:
                stderr = self.stderr.output
            else:
                stderr = self.stderr.output.encode("utf-8")
        elif isinstance(self.stderr, str):
            if self.text:
                stderr = self.stderr
            else:
                stderr = self.stderr.encode("utf-8")
        else:
            self.stderr.seek(0)
            try:
                stderr = self.stderr.read()
            except io.UnsupportedOperation:
                stderr = ""
            self.stderr.seek(0)

        return (stdout, stderr)

    def __enter__(self):
        return self
    
    def __exit__(self, exc_type, value, traceback):
        pass