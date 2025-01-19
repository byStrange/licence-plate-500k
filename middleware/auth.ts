
export default defineNuxtRouteMiddleware(async (to, from) => {
  const supabase = useSupabaseClient() // Access the Supabase client

  // Check if the user is logged in
  const { data: { user }, error } = await supabase.auth.getUser();
  console.log(error)
  console.log(user)

  if (!user) {
    // If no user, redirect to the login page
    return navigateTo('/auth/login');
  }
});
