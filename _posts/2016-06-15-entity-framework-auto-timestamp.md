---
id: 111
title: CreatedAt property with Entity framework
date: 2016-06-15T14:13:48+01:00


guid: https://svrooij.nl/?p=111
old_permalink: /2016/06/entity-framework-auto-timestamp/
twitter_image: /assets/images/2015/04/source_code1.png
categories:
  - Coding
tags:
  - Entity framework
---
You're building a new application, and you're using Entity Framework Code First. Probably all your entities need an **Id** and **CreatedAt/UpdatedAt** property.

The sample below shows you how to define these properties in a base class, and (more importantly) how to set them correctly on every save, without setting them manually on every place where you're changing things.

<!--more-->

We do this by _overriding_ the **SaveChanges** method of the **DbContext**.


```csharp
    [Table("Blogs")]
    // We inherit the EntityBase class here (with Id, CreatedAt and UpdatedAt)
    public class Blog : EntityBase
    {

        [MaxLength(150)]
        [Required]
        public string Name { get; set; }
        
        [Required]
        [DataType(DataType.MultilineText)]
        public string Text { get; set;}
    }

    public class BlogsDatabase : DbContext
    {
        public InternshipDatabase() : base("BlogsDB") { }
        public DbSet<Blog> Blogs { get; set; }

        // Lets override the default save changes, so we automaticaly change the UpdatedAt field.
        public override int SaveChanges()
        {
            foreach (var entry in ChangeTracker.Entries().Where(x => x.Entity.GetType().GetProperty("CreatedAt") != null))
            {
                if (entry.State == EntityState.Added)
                {
                    entry.Property("CreatedAt").CurrentValue = DateTime.Now;
                }
                else if (entry.State == EntityState.Modified)
                {
                    // Ignore the CreatedTime updates on Modified entities. 
                    entry.Property("CreatedAt").IsModified = false;
                }
                // Always set UpdatedAt. Assuming all entities having CreatedAt property
                // Also have UpdatedAt
                entry.Property("UpdatedAt").CurrentValue = DateTime.Now;
            }
            return base.SaveChanges();
        }
    }

    public class EntityBase
    {
        [Key]
        public Guid Id { get; set; } = Guid.NewGuid();
        public DateTime? CreatedAt { get; set; } = DateTime.Now;
        public DateTime? UpdatedAt { get; set; } = DateTime.Now;
    }
```
I hope you like my sample, so please let me know below or share this post on social media.
