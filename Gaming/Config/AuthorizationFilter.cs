using Gaming.Controllers;
using Gaming.Data;
using Gaming.Models;

namespace Gaming.Config;

using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;
/// <summary>
/// Gestion des autorisation
/// </summary>
public class AuthorizationFilter : IAuthorizationFilter
{
    public void OnAuthorization(AuthorizationFilterContext context)
    {
        var user = context.HttpContext.User;

        // Vérifier si l'utilisateur est authentifié
        if (!user.Identity.IsAuthenticated)
        {
            // L'utilisateur n'est pas connecté, rediriger vers la page de connexion
            context.Result = new RedirectToRouteResult(new { controller = "Home", action = "Login" });
        }
    }
}

