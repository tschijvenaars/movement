using core_backend.Models;
using Duende.IdentityServer.EntityFramework.Options;
using Microsoft.AspNetCore.ApiAuthorization.IdentityServer;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;

namespace core_backend.Data
{
    public class ApplicationDbContext : ApiAuthorizationDbContext<ApplicationUser>
    {
        public ApplicationDbContext(DbContextOptions options, IOptions<OperationalStoreOptions> operationalStoreOptions)
            : base(options, operationalStoreOptions)
        {

        }
        
        //Logs
        public DbSet<ErrorLog> ErrorLogs { get; set; }

        //Odin data
        public DbSet<ClassifiedPeriod> ClassifiedPeriods { get; set; }
        public DbSet<Stop> Stops { get; set; }
        public DbSet<Movement> Movements { get; set; }
        public DbSet<Vehicle> Vehicles { get; set; }
        public DbSet<Reason> Reasons { get; set; }
        public DbSet<ManualGeolocation> ManualGeolocations { get; set; }
        public DbSet<SensorGeolocation> SensorGeolocations { get; set; }
        public DbSet<TrackedDay> TrackedDays { get; set; }
        public DbSet<Device> Devices { get; set; }
        public DbSet<Questionnaire> Questionnaires { get; set; }

        //Google
        public DbSet<GoogleErrorLog> GoogleErrorLogs { get; set; }
        public DbSet<GoogleLog> GoogleLogs { get; set; }
        public DbSet<GoogleMapsData> GoogleMapsDatas { get; set; }
    }
}