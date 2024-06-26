//
//  PyAction.swift
//  Pyto
//
//  Created by Emma Labbé on 30-06-19.
//  Copyright © 2018-2021 Emma Labbé. All rights reserved.
//

import Foundation

/// This class is used to represent a Python object. This object contains a reference to it.
@objc public class PyValue: NSObject {
    
    deinit {
        print("Deallocated \(self)")
    }
    
    /// The name of the object stored in `_values` module.
    @objc public var identifier: String
    
    /// The path of the script that created the value.
    @objc public var scriptPath: String?
    
    @objc private static var scriptPath: String?
    
    /// Initialize the value.
    ///
    /// - Parameters:
    ///     - identifier: The name of the object stored in `_values` module.
    @objc public init(identifier: String) {
        
        self.identifier = identifier
        
        super.init()
    }
    
    /// Calls the value as a function.
    ///
    /// - Parameters:
    ///     - parameter: The parameter to pass.
    ///     - sync: If set to `true`, will execute the function synchronously.
    ///     - delete: If set to `true`, the parameter will be deleted from the register after running.
    @objc func call(parameter: PyValue?, sync: Bool = false, delete: Bool = false) {
        
        var code = "import threading\n"
        
        if let path = scriptPath {
            PyValue.scriptPath = path
            code += """
            from _Pyto import PyValue

            script_path = str(PyValue.scriptPath)
            """
        } else {
            code += """
            script_path = None
            """
        }
        
        let deleter = parameter != nil ? "\nimport _values; del _values.\(parameter!.identifier)" : ""
        
        if let param = parameter {
            code += """

            code = '''import _values
                        
            if "\(param.identifier)" in dir(_values) and "\(identifier)" in dir(_values):
            
                param = _values.\(param.identifier)
                func = _values.\(identifier)
                if func.__code__.co_argcount == 1 and "__self__" in dir(func):
                    func()
                elif func.__code__.co_argcount >= 1:
                    func(param)
                else:
                    func()'''

            """
        } else {
            code += """

            code = '''import _values
            
            if "\(identifier)" in dir(_values):
                _values.\(identifier)()'''

            """
        }
        
        if sync {
            
            code += "\nexec(code)"
            
            if delete {
                code += deleter
            }
            
            Python.pythonShared?.perform( #selector(PythonRuntime.runCode(_:)), with: code)
        } else {

            code += """
            thread = threading.Thread(target=exec, args=(code,))
            if script_path is not None:
                thread.script_path = script_path
            thread.start()
            """
            
            if delete {
                code += deleter
            }

            Python.shared.run(code: code)
        }
    }
}
