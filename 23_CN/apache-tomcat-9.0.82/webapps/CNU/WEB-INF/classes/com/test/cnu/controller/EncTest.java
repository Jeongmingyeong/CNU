package com.test.cnu.controller;

import org.jasypt.encryption.pbe.StandardPBEStringEncryptor;

public class EncTest {

	public static void main(String[] args) { 
		
		// TODO Auto-generated method stub 
		StandardPBEStringEncryptor pbeEnc = new StandardPBEStringEncryptor(); 
		pbeEnc.setAlgorithm("PBEWithMD5AndDES"); 
		pbeEnc.setPassword("test!!@@"); 
		String url = "jdbc:log4jdbc:mysql://localhost:3306/mydatabase?serverTimezone=UTC"; 
		String username = "test"; 
		String password = "test"; 
		System.out.println("기존 URL :: " + url + " | 변경 URL :: " + pbeEnc.encrypt(url)); 
		System.out.println("기존 username :: " + username + " | 변경 username :: " + pbeEnc.encrypt(username)); 
		System.out.println("기존 password :: " + password + " | 변경 password :: " + pbeEnc.encrypt(password)); 
		String encPass = pbeEnc.encrypt(password);
		String des = pbeEnc.decrypt(encPass);
		System.out.println("복호화 password ::"+des);
	} 
}
