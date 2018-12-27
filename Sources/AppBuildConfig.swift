//
//  AppBuildConfig.swift
//  Android
//
//  Created by Marco Estrella on 12/27/18.
//

import Foundation
import java_swift
import java_lang
import JNI

public let isLoggingEnabled: Bool = AppBuildConfig.DEBUG.rawValue

fileprivate struct AppBuildConfig: RawRepresentable, Equatable {
    
    public let rawValue: Bool
    
    public init(rawValue: Bool) {
        self.rawValue = rawValue
    }
    
    public static let DEBUG = AppBuildConfig(rawValue: AndroidBuildConfig.DEBUG)
}

fileprivate class AndroidBuildConfig: JavaObject {
    
    public convenience init?( casting object: java_swift.JavaObject,
                              _ file: StaticString = #file,
                              _ line: Int = #line ) {
        self.init(javaObject: nil)
        
        object.withJavaObject {
            self.javaObject = $0
        }
    }
    
    public required init( javaObject: jobject? ) {
        super.init(javaObject: javaObject)
    }
    
    public static var DEBUG: Bool {
        
        get {
            
            let __value = JNIField.GetStaticBooleanField(
                fieldName: "DEBUG",
                fieldType: "Z",
                fieldCache: &JNICache.FieldID.DEBUG,
                className: JNICache.className,
                classCache: &JNICache.jniClass )
            
            return __value != jboolean(JNI_FALSE)
        }
    }
}

// MARK: - JNICache

fileprivate extension AndroidBuildConfig {
    
    /// JNI Cache
    struct JNICache {
        
        /// JNI Java class name
        static var className: String {
            
            get {
                var className = UIApplication.shared.androidActivity.getPackageName().replacingOccurrences(of: ".", with: "/")
                
                className.append("/BuildConfig")
                
                return className
            }
        }
        
        /// JNI Java class
        static var jniClass: jclass?
        
        /// JNI Method ID cache
        struct FieldID {
            
            static var DEBUG: jfieldID?
        }
    }
}
