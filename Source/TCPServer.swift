// TCPServer.swift
//
// The MIT License (MIT)
//
// Copyright (c) 2015 Zewo
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import CLibvenice
import C7

public final class TCPServer {
    
    public var uri: URI
    private let backlog: Int32
    private let reusePort: Bool
    private var socket: tcpsock
    private var connection: TCPConnection?
    
    public init(for uri: URI) throws {
        self.uri = uri
        backlog = 128
        reusePort = false
        
        guard let host = uri.host else {
            throw TCPError.unknown(description: "Host was not defined in URI")
        }
        guard let port = uri.port else {
            throw TCPError.unknown(description: "Port was not defined in URI")
        }
        
        let ip = try IP(remoteAddress: host, port: port)
        socket = tcplisten(ip.address, self.backlog, reusePort ? 1 : 0)
    }
    
    public init(for uri: URI, backlog: Int = 128, reusePort: Bool = false) throws {
        self.uri = uri
        self.backlog = Int32(backlog)
        self.reusePort = reusePort
        
        guard let host = uri.host else {
            throw TCPError.unknown(description: "Host was not defined in URI")
        }
        guard let port = uri.port else {
            throw TCPError.unknown(description: "Port was not defined in URI")
        }
        
        let ip = try IP(remoteAddress: host, port: port)
        socket = tcplisten(ip.address, self.backlog, reusePort ? 1 : 0)
    }
    
    public func accept(timingOut deadline: Deadline = never) throws -> Connection {
        return try TCPConnection(with: tcpaccept(socket, deadline))
    }
    
}
