using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Proyecto2020Web.Context;
using Proyecto2020Web.Models;
using System.Collections.Generic;
using System.Linq;


namespace Proyecto2020Web.Controllers
{
    public class CuentaAhorro : Controller
    {
        readonly ConectarBaseDatos dbContext = new ConectarBaseDatos();

        // GET: CuentaAhorro
        public ActionResult Index()
        {
            List<CuentasAhorro> cuentasAhorro = dbContext.GetAllCuentaAhorro().ToList();
            return View(cuentasAhorro);
        }

        // GET: CuentaAhorro/Details/5
        public ActionResult Details(int id)
        {
            return View();
        }

        // GET: CuentaAhorro/Create
        public ActionResult Create()
        {
            return View();
        }

        // POST: CuentaAhorro/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create(IFormCollection collection)
        {
            try
            {
                return RedirectToAction(nameof(Index));
            }
            catch
            {
                return View();
            }
        }

        // GET: CuentaAhorro/Edit/5
        public ActionResult Edit(int id)
        {
            return View();
        }

        // POST: CuentaAhorro/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit(int id, IFormCollection collection)
        {
            try
            {
                return RedirectToAction(nameof(Index));
            }
            catch
            {
                return View();
            }
        }

        // GET: CuentaAhorro/Delete/5
        public ActionResult Delete(int id)
        {
            return View();
        }

        // POST: CuentaAhorro/Delete/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Delete(int id, IFormCollection collection)
        {
            try
            {
                return RedirectToAction(nameof(Index));
            }
            catch
            {
                return View();
            }
        }
    }
}
