#include <iostream>
#include <sys/stat.h>
#include <string>
#include <tuple>
#include <mutex>
#include <map>
#include <dlfcn.h>
#include <boost/any.hpp>
#include <pthread.h>

#include "opencog/atomspace_api.h"
#include <opencog/atomspace/AtomSpace.h>


int NO_SIGNAL_HANDLERS = 0; // Py InitEx parameter; no signalhandlers as cpp threads take care of that (?)

class PythonIntegration
{ 
    public:
        /**
         * Constructor
         * ENSURE Singleton
         * Calls py_init
         */
        PythonIntegration(std::string);
        ~PythonIntegration();


        PyObject* get_atomspace();
        
        void set_atomspace(AtomSpace* as);

        /**
         * Runs python code from a file
         * @params: path to python file, function to be called, arguments
         *
         * if no function name is specified, the main function is executed
         */
        PyObject* run_py_script(const char*, const char*, const char*);
        
        PyObject* run_py_command(const char*, int)

    private:
        PyObject*                            _atomspace;
        PythonIntegration*                   _singleton_instance;
        bool                                 _initialized_outside2;
        bool                                 _initialized_outside3;
        boost::any                           _main_thread_state2; // PyThreadState* 
        boost::any                           _main_thread_state3; // PyThreadState* 
        void*                                _py2_handle;
        void*                                _py3_handle;
        boost::any                           _gstate2; // PyGILState_STATE
        boost::any                           _gstate3; // PyGILState_STATE
        std::map<std::string, boost::any>    _py2_api; // void or PyObject
        std::map<std::string, boost::any>    _py3_api; // void or PyObject
        std::string                          _result;

        struct SaveAS {
            PyObject* _save_as;
            PythonEval* p_eval;

            SaveAS(PythonEval* p_eval, Atomspace* as)
                { _save_as = p_eval->_atomspace; p_eval->_atomspace = py_atomspace(as) }
            
            ~SaveAS() { p_eval->_atomspace = this->_save_as; }
        }
        
        /** 
         * Imports the atomspace and opencog python packages
         */
        void py_import_oc_pkg();
        
        void py_init_env();

        PyObject* atomspace_to_py(AtomSpace*);

        /**
         * Dynamically loads & links the python symbols into the process space
         * dl 2 -> Exec 2 -> safe to PyEval
         * dl 3 -> Exec 3 -> safe to PyEval
         * TODO How to handle both versions at the same time?
         */
        void py_dload();
       
        void check_dlopen_err(void*);

        void check_dlsym_err();

        int check_shebang(const char*)

        void demo();
};

