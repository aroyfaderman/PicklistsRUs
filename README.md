# PicklistsRUs
Sample application for custom metadata types: "Reusable picklists" framework and tooling.

Please note that this is only an example, intended to help people understand working with custom
metadata types) and not an attempt to implement a fully-functional framework for reusable picklists. 

Things the sample can do:
- Operate either as a managed or unmanaged package or uploaded directly to an organization 
  (although it contains a lot of unnecessary code for the latter)
- Allow declarative creation of "reusable picklists" that can be used to make text fields
  display as dropdown lists in a very simple UI
- Allow these "reusable picklists" to be deployed from sandbox or packaged, either with the 
  original package or as part of an extension

You'll notice the framework contains three permission sets. One is required to use the application
at all; one is required to create picklists and assign them to fields (and grants the Customize Application
permission) to anyone it is assigned to; and one is for Apex tests only and does not need to be granted to anyone. The names and descriptions should make it obvious which is which.


